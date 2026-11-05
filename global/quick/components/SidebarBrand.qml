import QtQuick

Item {
    id: root

    property real uiScale: 1

    implicitHeight: 56 * uiScale

    Text {
        anchors.centerIn: parent
        visible: root.width >= implicitWidth + 24 * root.uiScale
        text: "meowdots"
        color: "white"
        font.bold: true
        font.pixelSize: 18 * root.uiScale
    }
}
