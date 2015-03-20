'''
Created on Jan 19, 2015

@author: owwlo
'''
import logging
import sys
from PyQt5 import QtGui, QtCore, QtQml, QtQuick
from PyQt5.QtCore import QObject, QUrl, Qt
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu, QAction
from PyQt5.QtQml import QQmlApplicationEngine
import coloredlogs
import threading
import qrcode

logger = logging.getLogger("CourierAppGui")
coloredlogs.install(level = logging.DEBUG, show_hostname = False, show_timestamps = False)

class GuiMain(object):

    def __init__(self, service, app):
        self.__service = service
        self.__app = app

        self.setUpTrayIcon()
        self.setTrayVisiable(True)

        service.addOnNewMessageFromDevice(self.onNewMessage)
        service.addOnTokenFetched(self.onTokenFetched)
        service.addOnDeviceConnected(self.onDeviceConnected)

        # For test purpose
        self.testQRCode()

    def setUpTrayIcon(self):
        # Prepare tray icon
        self.__trayIcon = QSystemTrayIcon(
            QtGui.QIcon.fromTheme("edit-undo"), self.__app)
        menu = QMenu()
        exitAction = QAction("&Exit", menu)
        menu.addAction(exitAction)

        exitAction.triggered.connect(self.onMenuExit)
        self.__trayIcon.setContextMenu(menu)

    def onMenuExit(self):
        # TODO: gracefully exit
        sys.exit()

    def setTrayVisiable(self, visible):
        self.__trayIcon.setVisible(visible)

    def onNewMessage(self, message):
        logger.debug("Got message in Gui: " + str(message))
        messages = message["messages"]
        idx = 0
        for msg in messages:
            logger.info("Msg %d, recv_time: %s, sender: %s, content: %s" % (idx, msg["recv_time"], msg["sender"], msg["content"]))
            idx += 1

    def onTokenFetched(self, token):
        logger.debug("New token fetched from server: " + str(token))
        self.showQRCode(token)

    def onDeviceConnected(self, message):
        logger.debug("New Device Connected.")

    def testQRCode(self):
        self.showQRCode("hfoiwejfpewokf")

    def showQRCode(self, token):
        qmlRegisterType(Message, 'Message', 1, 0, 'Message')

        qrImg = Message()
        qrImg.img(qrcode.make(token))
        window = QQmlApplicationEngine(QUrl('qrcode.qml'), self.__app)
        window.rootContext().setContextProperty("qrImg", qrImg)

class Message(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._img = ''

    @pyqtProperty('QImage')
    def img(self):
        return self._img

    @img.setter
    def img(self, img):
        self._img = img