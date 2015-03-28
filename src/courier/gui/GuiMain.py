'''
Created on Jan 19, 2015

@author: owwlo
'''
from PyQt5              import QtGui, QtCore, QtQml, QtQuick
from PyQt5.QtCore       import QObject, QUrl, Qt, QVariant, QMetaObject, Q_ARG
from PyQt5.QtWidgets    import QApplication, QSystemTrayIcon, QMenu, QAction
from PyQt5.QtQml        import QQmlApplicationEngine
from StringIO           import StringIO
from collections        import deque
import logging
import sys
import coloredlogs
import threading
import qrcode
import base64
import math

# For PNG support
# from qrcode.image.pure import PymagingImage

logger = logging.getLogger("CourierAppGui")
coloredlogs.install(level = logging.DEBUG, show_hostname = False, show_timestamps = False)

NOTIFICATION_WINDOW_HEIGHT = 190
NOTIFICATION_WINDOW_WIDTH = 480

class NotificationMan():
    def __init__(self, service, app, guiMain):
        self.__service = service
        self.__app = app
        self.__guiMain = guiMain

        self.aliveNotificationCount = 0

        # TODO: Find a better way to get the proper screen number.
        screenId = app.desktop().screenNumber(app.desktop().cursor().pos())
        screenRes = app.desktop().screenGeometry(screenId)

        self.__notificationEndX = screenRes.x() + screenRes.width()
        self.__notificationStartX = self.__notificationEndX - NOTIFICATION_WINDOW_WIDTH
        self.__notificationStartY = screenRes.y()
        self.__notificationEndY = screenRes.y() + screenRes.height()
        self.__maxNotificationWindowCount = int(math.floor(screenRes.height() / NOTIFICATION_WINDOW_HEIGHT))

        self.__notificationWindowMask = [False] * self.__maxNotificationWindowCount

        self.__notificationWaitingQueue = deque()

    def on_qml_reply(self, replyText):
        print replyText    

    def on_qml_dismissed(self):
        print "dismessed"

    def on_notificationWindowClosed(self, pos):
        self.__notificationWindowMask[pos] = False
        self.checkNotificationQueue()

    def checkNotificationQueue(self):
        if len(self.__notificationWaitingQueue) > 0:
            msg = self.__notificationWaitingQueue.pop()
            self.addNewNotification(msg)

    def addNewNotification(self, message):
        availablePos = -1
        for idx in range(0, self.__maxNotificationWindowCount):
            if not self.__notificationWindowMask[idx]:
                availablePos = idx
                break

        if availablePos == -1:
            self.__notificationWaitingQueue.append(message)
        else:
            self.__notificationWindowMask[availablePos] = True

            windowPosX = int(self.__notificationStartX)
            windowPosY = int(self.__notificationStartY + availablePos * NOTIFICATION_WINDOW_HEIGHT) + 20

            window = QQmlApplicationEngine(QUrl('NewMessageWindow.qml'), self.__app)
            qmlRoot = window.rootObjects()[0]
            qmlRoot.setProperty("x", windowPosX)
            qmlRoot.setProperty("y", windowPosY)
            qmlRoot.setProperty("posIdx", availablePos)

            # Set up signals and slots
            qmlRoot.dismissed.connect(self.on_qml_dismissed)
            qmlRoot.reply.connect(self.on_qml_reply)
            qmlRoot.closed.connect(self.on_notificationWindowClosed)

            QMetaObject.invokeMethod(qmlRoot, "test", Qt.AutoConnection)


class GuiMain(object):

    def __init__(self, service, app):
        self.__service = service
        self.__app = app
        self.__notificationMan = NotificationMan(service, app, self)

        self.setUpTrayIcon()
        self.setTrayVisiable(True)

        service.addOnNewMessageFromDevice(self.onNewMessage)
        service.addOnTokenFetched(self.onTokenFetched)
        service.addOnDeviceConnected(self.onDeviceConnected)

        # For test purpose
        self.testQRCode()
        self.__notificationMan.addNewNotification("None")

    def getNotificationMan(self):
        return self.__notificationMan

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
        self.showQRCode("test purpose fake token string")

    def showQRCode(self, token):
        # Build QRCode image
        imageBuffer = StringIO()
        qr = qrcode.QRCode(
            box_size=20,
            border=1,
        )
        qr.add_data(token)
        qr.make_image().save(imageBuffer)

        # Encode into Base64
        encodedQrImg = base64.b64encode(imageBuffer.getvalue())

        # Load QML
        window = QQmlApplicationEngine(QUrl('qrcode.qml'), self.__app)

        # Call functions to update content
        qmlRoot = window.rootObjects()[0]
        QMetaObject.invokeMethod(qmlRoot, "setQrCodeImage", Qt.AutoConnection, Q_ARG("QVariant", QVariant(encodedQrImg)))

        # Move center of screen
        frameGm = qmlRoot.frameGeometry()
        screenId = self.__app.desktop().screenNumber(self.__app.desktop().cursor().pos())
        windowPos = self.__app.desktop().screenGeometry(screenId).center()
        frameGm.moveCenter(windowPos)
        qmlRoot.setPosition(frameGm.topLeft())