import QtQuick 2.4
import QtQuick.Controls 1.3

ApplicationWindow {
    title: qsTr("New Message")
    width: 480
    height: 190
    visible: true
    color: "transparent"
    id: mainWindow
    flags: Qt.FramelessWindowHint

    property int posIdx
    property string conversationId

    signal dismissed(string cId)
    signal reply(string text, string cId)
    signal closed(int posId)

    function updateMessage(userImages, msgs) {
        for(var idx in msgs) {
            var messageMap = msgs[idx];
            messageModel.append({
                                    "mIsHost": messageMap["isHost"],
                                    "mContent": messageMap["content"],
                                    "mUserImage": userImages[messageMap["userId"]]
                                });
        }
    }

    function setConfig(msg) {
        mainWindow.conversationId = msg["conversationId"];
        updateMessage(msg["userImages"], msg["messages"]);
    }

    ListModel {
        id: messageModel
    }

    Component {
        id: listDelegate

        Item {
            id: delegateItem
            width: listView.width
            height: dialogItem.height

            DialogItem {
                id: dialogItem
                isHost: mIsHost
                content: mContent
                userImage: mUserImage
                anchors.right: parent.right
                anchors.left: parent.left
            }

            ListView.onAdd:
                SequentialAnimation {
                    PropertyAction {
                        target: delegateItem
                        property: "height"
                        value: 0
                    }
                    PropertyAction {
                        target: delegateItem
                        property: "opacity"
                        value: 0
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: delegateItem
                            property: "height"
                            to: delegateItem.height
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            target: delegateItem
                            property: "opacity"
                            to: 1
                            duration: 500
                            easing.type: Easing.InOutQuad
                        }
                    }
                    ScriptAction {
                        script: {
                            listView.positionViewAtEnd();
                        }
                    }
                }

            ListView.onRemove: SequentialAnimation {
                PropertyAction {
                    target: delegateItem
                    property: "ListView.delayRemove"
                    value: true
                }
                ParallelAnimation {
                    NumberAnimation {
                        target: delegateItem
                        property: "height"
                        to: 0
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        target: delegateItem
                        property: "opacity"
                        to: 0
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
                PropertyAction {
                    target: delegateItem
                    property: "ListView.delayRemove"
                    value: false
                }
            }
        }
    }
    Item {
        id: renderArea
        z: 1
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 13
        anchors.topMargin: 8
        anchors.fill: parent

        Item {
            id: headerItem
            height: 30
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0

            Rectangle {
                id: rectangle1
                color: "#00e00000"
                border.color: "#00000000"
                anchors.fill: parent

                UpperBar {
                    id: upperBar
                    onDismissed: {
                        mainWindow.dismissed(mainWindow.conversationId)
                        mainWindow.closed(mainWindow.posIdx)
                        mainWindow.close()
                    }
                }
            }
        }

        Item {
            id: messageShowItem
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: replyItem.top
            anchors.top: headerItem.bottom

            Rectangle {
                id: rectangle2
                color: "#001a00e9"
                border.color: "#00000000"
                anchors.fill: parent
            }

            ListView {
                id: listView
                anchors.rightMargin: 2
                anchors.leftMargin: 2
                clip: true
                anchors.fill: parent
                model: messageModel
                delegate: listDelegate
                spacing: 5
            }
        }

        Item {
            id: replyItem
            height: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            Rectangle {
                id: rectangle3
                color: "#005cff09"
                border.color: "#00000000"
                anchors.fill: parent

                InputBox {
                    id: inputBox
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom

                    onReplyMessageAccepted: {
                        mainWindow.reply(message, mainWindow.conversationId);
                        mainWindow.closed(mainWindow.posIdx)
                        mainWindow.close()
                    }
                }
            }
        }
    }

    BorderImage {
        id: borderImage1
        border.bottom: 20
        border.top: 10
        border.right: 10
        border.left: 10
        anchors.fill: parent
        source: "Courier.Cut/back.png"
    }
}

