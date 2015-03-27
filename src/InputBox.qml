import QtQuick 2.4

Item {
    id: inputBox
    height: 25
    state: "INFORMING"
    signal replyMessageAccepted(string message)

    BorderImage {
        id: border_image1
        height: parent.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        border.bottom: 8
        border.top: 6
        border.right: 8
        border.left: 6
        clip: false
        source: "Courier.Cut/inputBox.png"
    }

    TextInput {
        id: responseTextInput
        y: 54
        height: 20
        text: qsTr("回复给${MESSAGE_SENDER}...")
        anchors.verticalCenterOffset: 1
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        font.bold: true
        font.family: "微软雅黑"
        font.pixelSize: 12

        onFocusChanged:{
            if (responseTextInput.activeFocus && responseTextInput.font.italic == true) {
                inputBox.state = "INPUTTING"
                responseTextInput.text = ""
            }
        }
        onAccepted: {
            inputBox.replyMessageAccepted(responseTextInput.text);
            responseTextInput.text = "";
        }
    }

    states: [
        State {
            name: "INFORMING"
            PropertyChanges {
                target: responseTextInput
                color: "#cdcdcd"
                font.italic: true
            }
        },
        State {
            name: "INPUTTING"
            PropertyChanges {
                target: responseTextInput
                color: "#111111"
                font.italic: false
            }
        }
    ]
}
