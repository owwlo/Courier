import QtQuick 2.2
import QtQuick.Controls 1.1

ApplicationWindow {
    id: applicationWindow1
    color: "transparent"
    title: "QR Code"
    visible: true
    width: 320
    height: 340

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }


    BorderImage {
        id: borderImage1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        border.bottom: 40
        border.top: 20
        border.right: 20
        border.left: 20
        anchors.fill: parent
        source: "Courier.Cut/back.png"
    }

    Column {
        id: column1
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        clip: false
        anchors.fill: parent

        Row {
            id: titleBarRow
            height: 40
            antialiasing: false
            spacing: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.left: parent.left

            MouseArea {
                id: frameMoveMouseArea
                anchors.fill: parent
            }

            Text {
                id: text1
                y: 0
                text: qsTr("Scan with Courier")
                font.family: "Tahoma"
                horizontalAlignment: Text.AlignHCenter
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
            }
        }

        Row {
            id: contentRow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 18
            anchors.top: titleBarRow.bottom
            anchors.topMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 16

            Image {
                id: qrImage
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
                source: "qrc:/qtquickplugin/images/template_image.png"
            }
        }
    }

    function setQrCodeImage(imgData) {
        qrImage.source = "data:image/png;base64," + imgData
        return
    }
}
