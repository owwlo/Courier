import QtQuick 2.4

Item {
    id: upperbarMain
    width: parent.width
    height: 30

    property string senderName;
    property string senderPhone;

    signal dismissed()

    Text {
        id: title
        height: 18
        text: "同" + senderName + "(" + senderPhone + ")的会话"
        anchors.leftMargin: 5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        styleColor: "#c8ffffff"
        style: Text.Raised
        font.bold: true
        font.pixelSize: 12
        font.family: "微软雅黑"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
    }

    Image {
        id: image1
        width: 40
        height: 14
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        source: "Courier.Cut/dismissButton.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
               upperbarMain.dismissed()
            }
        }
    }

}
