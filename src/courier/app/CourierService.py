'''
Created on Jan 17, 2015

@author: owwlo
'''

from PyQt5              import QtGui, QtCore, QtQml, QtQuick
from PyQt5.QtCore       import QObject, QUrl, Qt, QVariant, QMetaObject, Q_ARG
import threading
import websocket
import json
import logging
from time import sleep
import coloredlogs

WS_URL = "ws://localhost:8888/computer"

RECONNECT_INTERVAL = 5

logger = logging.getLogger("CourierApp")
coloredlogs.install(level = logging.DEBUG, show_hostname = False, show_timestamps = False)

class CourierService(threading.Thread, QObject):

    class WebSocketHandler():

        def __init__(self, service):
            self.__service = service

        def onMessage(self, ws, message):
            self.__service.onMessage(message)

        def onError(self, ws, error):
            logger.debug("onError " + str(error))

        def onClose(self, ws):
            logger.debug("onCLose")
            self.__service.ws = None

        def onOpen(self, ws):
            logger.debug("onOpen")
            self.__service.ws = ws
            self.__service.token = None

            fetchThread = threading.Thread(target=self.__service.fetchToken)
            fetchThread.start()
            # fetchThread.join()

    onTokenFetched = QtCore.pyqtSignal([str])
    onNewMessage = QtCore.pyqtSignal([dict])

    def __init__(self, app):
        threading.Thread.__init__(self)
        QObject.__init__(self, app)

        self.__app = app
        self.handler = self.WebSocketHandler(self)
        self.token = None

        # Initialize callback lists for 
        self.__callbacksOnNewMessageFromDevice = []
        self.__callbacksOnTokenFetched = []
        self.__callbacksOnDeviceConnected = []

    def run(self):
        while(True):
            ws = websocket.WebSocketApp(WS_URL,
                                    on_message=self.handler.onMessage,
                                    on_error=self.handler.onError,
                                    on_close=self.handler.onClose,
                                    on_open=self.handler.onOpen)
            ws.run_forever()
            logger.error("Lost connection, will try again in %d seconds." % RECONNECT_INTERVAL)
            sleep(RECONNECT_INTERVAL)

    def fetchToken(self):
        MAX_RETRY_CNT = 5
        cnt = MAX_RETRY_CNT
        while cnt > 0 and self.token == None:
            if cnt != MAX_RETRY_CNT:
                logger.warn(
                    "Connect failed, reconnecting... trying count remains: %d" % cnt)
            self.sendHash(self.getTokenRequestPackage())
            sleep(5)
            cnt -= 1
        if self.token == None:
            logger.error("Cannot connect to server")
        # else:
        #     self.on

    def getTokenRequestPackage(self):
        return {"type": "operation", "command": "request_token"}

    def getReplyRequestPackage(self, cId, replyText):
        return {"type": "reply", "cId": str(cId), "content": replyText}

    def sendReply(self, cId, replyText):
        pkg = self.getReplyRequestPackage(cId, replyText)
        self.sendHash(pkg)

    def parseMessage(self, message):
        parsed = None
        try:
            parsed = json.loads(message)
        except Exception as e:
            logger.warn(str(e))
            return None
        return parsed

    def sendHash(self, h):
        if self.token:
            h["token"] = self.token
        j = json.dumps(h)
        self.send(j)

    def send(self, message):
        if self.ws != None:
            self.ws.send(message)
        else:
            logger.error("Socket Failed.")

    def onMessage(self, message):
        logger.debug("Raw Message from Server: " + message)
        msg = self.parseMessage(message)
        if msg == None:
            return
        mtype = msg["type"]
        if mtype == "new_msg":
            self.onNewMessageFromDevice(msg)
        elif mtype == "token_response":
            self.onTokenResponse(msg)
        elif mtype == "info_paired":
            self.onDeviceConnected(msg)

    def onTokenResponse(self, message):
        logger.debug("Get token from server: " + message["token"])
        self.token = message["token"]
        for fn in self.__callbacksOnTokenFetched:
            fn(self.token)
        self.onTokenFetched.emit(self.token)

    def onNewMessageFromDevice(self, message):
        for fn in self.__callbacksOnNewMessageFromDevice:
            fn(message)
        self.onNewMessage.emit(message)

    def onDeviceConnected(self, message):
        for fn in self.__callbacksOnDeviceConnected:
            fn(message)

    def addOnNewMessageFromDevice(self, callback):
        self.__callbacksOnNewMessageFromDevice.append(callback)

    def removeOnNewMessageFromDevice(self, callback):
        self.__callbacksOnNewMessageFromDevice.remove(callback)

    def addOnTokenFetched(self, callback):
        self.__callbacksOnTokenFetched.append(callback)

    def removeOnTokenFetched(self, callback):
        self.__callbacksOnTokenFetched.remove(callback)

    def addOnDeviceConnected(self, callback):
        self.__callbacksOnDeviceConnected.append(callback)

    def removeOnDeviceConnected(self, callback):
        self.__callbacksOnDeviceConnected.remove(callback)
