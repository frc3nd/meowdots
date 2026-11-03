import QtQuick

Item {
    id: root

    readonly property var tabs: ["main", "appearance"]
    property string currentTab: "main"

    Text {
        anchors.centerIn: parent
        text: "DriftWM"
        color: "white"
    }
}
