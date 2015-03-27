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

    signal dismissed()
    signal reply(string text)

    function updateMessage(m) {
        for(var idx in m) {
            var messageMap = m[idx]
            messageModel.append({
                                    "mIsHost": messageMap["isHost"],
                                    "mContent": messageMap["content"],
                                    "mUserImage":messageMap["userImage"]
                                });
        }
    }

    function test() {
        var messages = [
                {
                    "content": "The actual parameter (or argument expression) is fully evaluated and the resulting value is copied into a location being used to hold the formal parameter's value during method/function execution.",
                    "isHost": true,
                    "userImage": "iVBORw0KGgoAAAANSUhEUgAAAmwAAAJsAQAAAABo7sKIAAADMklEQVR4nO3dQXLjIBCF4ddT3qMb+P7H8g3gBD0LgUAIpyqMK0PsvxexLImv0qsuhGib64WR/rxSk+Dg4ODgVuDkHp+dC+5S8CbyVXd/MmztZOHg4ODg/oFr60GUcoV4mLk/zPKtyUwK7mZbPnMZ9iuShYODg4P7ZtzyZ9r2z/aRVHCZJJlClB2nXcnKff2wtZOFg4ODg3sll8ykZOYepTq5aB9O/cf/Dg4ODg7uR7nb0yvWzCsk+T6HSJu+Wg1fO1k4ODg4uKkotSIMKkCyUiGUS0c5inoybO1k4eDg4OCmYq8VNrjizWJE2ppVinp0HbZ2snBwcHBwU3EbTylKtNUgeHkuFVxPhq2dLBwcHBzcXOTV6/Lea903kTdUdOvYYbC1ItSxaycLBwcHBzcXlzJRq8F1L163oeJSXagVcHBwcO/INdOHy5Sii9CWiXrfqXSsnSwcHBwc3CyXrFmVaFt5xPODqGQltgG0P6taPlk4ODg4uFnO/ZFrQFsNgruZHdvwuvlHWcg4lY7fkCwcHBwc3HejW9u+LFDEwX2nCydq7WTh4ODg4Ga57k2n8kgqTzPuuTTkc3Z+YBW7trPLJwsHBwcHNxHt0rS3L8mOphSjt6R4ZxYODg7u3bmyb7vsrHMlk9ouHrFpClVvbtvONsDaycLBwcHBTcVNbcenqNF+bB98zTUlWTm39/1YO1k4ODg4uLmoi9X5a5S6bXj5ztOid72Z/RVwcHBw784N1yvGpUP56FQc2qvUCjg4OLj35K6dPXTMF8qFtn6Ey4bu06L32snCwcHBwc2FDyOOJg2DYbF7X2rtZOHg4ODgZrnau6OEpGM/djLrFi3yUd2HcWd/BRwcHNwHcN2U4rKOncxqU6jRj26b3ekHBQcHB/eu3KCv+PlPN6V4ul4hnkHBwcHBfRhX6oKZ5WdQuZyc5hXufrQXDMwr4ODg4D6Uc49HZ6jt+HpvJxe1iPz4fwcHBwcH9yPcLX+Ofj07bfKm+YeOVh5lt7btHUCalh9rJwsHBwcHNxWlH1QXaZP2GrBXg3gdmezo7CGVDlJrJwsHBwcHNxU2mE/MR1o7WTg4ODi4qfgLVLrSc9IR/boAAAAASUVORK5CYII="
                },{
                    "content": "I finally decided to write up a little something about Java's parameter passing. I'm really tired of hearing folks (incorrectly) state primitives are passed by value, objects are passed by reference",
                    "isHost": false,
                    "userImage": "iVBORw0KGgoAAAANSUhEUgAAAmwAAAJsAQAAAABo7sKIAAADMklEQVR4nO3dQXLjIBCF4ddT3qMb+P7H8g3gBD0LgUAIpyqMK0PsvxexLImv0qsuhGib64WR/rxSk+Dg4ODgVuDkHp+dC+5S8CbyVXd/MmztZOHg4ODg/oFr60GUcoV4mLk/zPKtyUwK7mZbPnMZ9iuShYODg4P7ZtzyZ9r2z/aRVHCZJJlClB2nXcnKff2wtZOFg4ODg3sll8ykZOYepTq5aB9O/cf/Dg4ODg7uR7nb0yvWzCsk+T6HSJu+Wg1fO1k4ODg4uKkotSIMKkCyUiGUS0c5inoybO1k4eDg4OCmYq8VNrjizWJE2ppVinp0HbZ2snBwcHBwU3EbTylKtNUgeHkuFVxPhq2dLBwcHBzcXOTV6/Lea903kTdUdOvYYbC1ItSxaycLBwcHBzcXlzJRq8F1L163oeJSXagVcHBwcO/INdOHy5Sii9CWiXrfqXSsnSwcHBwc3CyXrFmVaFt5xPODqGQltgG0P6taPlk4ODg4uFnO/ZFrQFsNgruZHdvwuvlHWcg4lY7fkCwcHBwc3HejW9u+LFDEwX2nCydq7WTh4ODg4Ga57k2n8kgqTzPuuTTkc3Z+YBW7trPLJwsHBwcHNxHt0rS3L8mOphSjt6R4ZxYODg7u3bmyb7vsrHMlk9ouHrFpClVvbtvONsDaycLBwcHBTcVNbcenqNF+bB98zTUlWTm39/1YO1k4ODg4uLmoi9X5a5S6bXj5ztOid72Z/RVwcHBw784N1yvGpUP56FQc2qvUCjg4OLj35K6dPXTMF8qFtn6Ey4bu06L32snCwcHBwc2FDyOOJg2DYbF7X2rtZOHg4ODgZrnau6OEpGM/djLrFi3yUd2HcWd/BRwcHNwHcN2U4rKOncxqU6jRj26b3ekHBQcHB/eu3KCv+PlPN6V4ul4hnkHBwcHBfRhX6oKZ5WdQuZyc5hXufrQXDMwr4ODg4D6Uc49HZ6jt+HpvJxe1iPz4fwcHBwcH9yPcLX+Ofj07bfKm+YeOVh5lt7btHUCalh9rJwsHBwcHNxWlH1QXaZP2GrBXg3gdmezo7CGVDlJrJwsHBwcHNxU2mE/MR1o7WTg4ODi4qfgLVLrSc9IR/boAAAAASUVORK5CYII="
                }
            ];
        updateMessage(messages);
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
                        mainWindow.dismissed()
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
                        mainWindow.reply(message);
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

