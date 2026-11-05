import QtQuick

Rectangle {
    id: root

    property bool checked: false
    property real uiScale: 1

    implicitWidth: 40 * uiScale
    implicitHeight: 22 * uiScale
    radius: height / 2
    color: checked ? "#888888" : "#444444"

    Rectangle {
        width: 16 * root.uiScale
        height: width
        radius: width / 2
        x: root.checked ? root.width - width - 3 * root.uiScale : 3 * root.uiScale
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.checked = !root.checked
    }
}
