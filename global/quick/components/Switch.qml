import QtQuick

Rectangle {
    id: root

    property bool checked: false

    implicitWidth: 40
    implicitHeight: 22
    radius: height / 2
    color: checked ? "#888888" : "#444444"

    Rectangle {
        width: 16
        height: 16
        radius: width / 2
        x: root.checked ? root.width - width - 3 : 3
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.checked = !root.checked
    }
}
