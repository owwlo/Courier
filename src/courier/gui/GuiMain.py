'''
Created on Jan 19, 2015

@author: owwlo
'''
import logging
import sys
from PyQt4 import QtGui, QtCore
import coloredlogs

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

    def setUpTrayIcon(self):
        # Prepare tray icon
        self.__trayIcon = QtGui.QSystemTrayIcon(
            QtGui.QIcon.fromTheme("edit-undo"), self.__app)
        menu = QtGui.QMenu()
        exitAction = QtGui.QAction("&Exit", menu)
        menu.addAction(exitAction)
        self.__app.connect(
            exitAction, QtCore.SIGNAL("triggered()"), self.onMenuExit)

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