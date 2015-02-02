'''
Created on Jan 17, 2015

@author: owwlo
'''
from courier.app.CourierService import CourierService
from courier.gui.GuiMain import GuiMain
import sys
from PyQt4 import QtGui
import cmd


class CommandManager(cmd.Cmd):

    prompt = '>> '
    intro = "Courier App Shell Tool."

    def __init__(self, gui, app, service):
        cmd.Cmd.__init__(self)
        self.__service = service
        self.__app = app
        self.__gui = gui

    def do_status(self, line):
        pass

    def do_raw(self, line):
        self.__service.send(line)

    def do_exit(self, line):
        sys.exit()

    def emptyline(self):
        pass


if __name__ == '__main__':
    app = QtGui.QApplication(sys.argv)
    service = CourierService()
    service.setDaemon(True)
    service.start()

    gui = GuiMain(service, app)

    cmdMgr = CommandManager(gui, app, service)
    cmdMgr.cmdloop()