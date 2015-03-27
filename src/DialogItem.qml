import QtQuick 2.4

Item {
    id: dialogItem
    property bool isHost: true
    property string content
    property int itemHeight
    property string userImage

    Component.onCompleted: {
        dialogText.text = content;
        userPic.source = "data:image/png;base64," + userImage
        group_A.height = dialogItem.height = Math.max(dialogText.height + 10, 51);
    }

    state: isHost ? "STATE_HOST" : "STATE_CLIENT"

    states: [
        State {
            name: "STATE_HOST"
            PropertyChanges {
                target: group_A
                anchors.rightMargin: 0
                anchors.leftMargin: 2
            }
            AnchorChanges {
                target: group_A
                anchors.right: parent.right
                anchors.left: group_B.right
            }
            PropertyChanges {
                target: dialogFrame
                source: "Courier.Cut/dialogFrame.png"
                border.right: 6
                border.left: 15
            }
            PropertyChanges {
                target: dialogText
                anchors.rightMargin: 6
                anchors.leftMargin: 14
            }
            PropertyChanges {
                target: group_B
                anchors.leftMargin: 0
            }
            AnchorChanges {
                target: group_B
                anchors.left: parent.left
                anchors.right: undefined
            }
        },
        State {
            name: "STATE_CLIENT"
            PropertyChanges {
                target: group_A
                anchors.rightMargin: 2
                anchors.leftMargin: 0
            }
            AnchorChanges {
                target: group_A
                anchors.right: group_B.left
                anchors.left: parent.left
            }
            PropertyChanges {
                target: dialogFrame
                source: "Courier.Cut/dialogFrame_R.png"
                border.right: 15
                border.left: 6
            }
            PropertyChanges {
                target: dialogText
                anchors.rightMargin: 14
                anchors.leftMargin: 6
            }
            PropertyChanges {
                target: group_B
                anchors.rightMargin: 0
            }
            AnchorChanges {
                target: group_B
                anchors.right: parent.right
                anchors.left: undefined
            }
        }
    ]

    Item {
        id: row1
        width: parent.width

        Rectangle {
            id: group_A
            color: "transparent"
            height: parent.height

            BorderImage {
                id: dialogFrame
                anchors.fill: parent
                border.bottom: 6
                border.top: 31
            }

            Text {
                id: dialogText
                color: "#8e8e8e"
                font.bold: true
                font.family: "微软雅黑"
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                width: parent.width - 24
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12

                Rectangle {
                    id: textArea
                    color:"transparent"
                    anchors.fill: parent
                }
            }
        }

        Rectangle {
            id: group_B
            width: 51
            height: 51
            color: "transparent"

            BorderImage {
                id: border_userPic
                z: 1
                anchors.fill: parent
                source: "Courier.Cut/picFrame.png"
            }

            Image {
                id: userPic
                smooth: true
                anchors.fill: parent
                anchors.margins: 1
                fillMode: Image.PreserveAspectFit
                source: "Courier.Cut/demoPic.png"
            }
        }
    }
}
