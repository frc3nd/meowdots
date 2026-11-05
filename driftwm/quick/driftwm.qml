import QtQuick

Item {
    id: root

    readonly property var tabs: ["main", "appearance"]
    property string currentTab: "main"
    property real uiScale: 1

    Text {
        anchors.centerIn: parent
        text: "DriftWM"
        color: "white"
        font.pixelSize: 14 * root.uiScale
    }
}
