'''
Created on Jan 19, 2015

@author: owwlo
'''
import logging
import sys
from PyQt5 import QtGui, QtCore, QtQml, QtQuick
from PyQt5.QtCore import QObject, QUrl, Qt, QVariant, QMetaObject, Q_ARG
from PyQt5.QtWidgets import QApplication, QSystemTrayIcon, QMenu, QAction
from PyQt5.QtQml import QQmlApplicationEngine
import coloredlogs
import threading
import qrcode
import base64
from StringIO import StringIO
# For PNG support
# from qrcode.image.pure import PymagingImage

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
