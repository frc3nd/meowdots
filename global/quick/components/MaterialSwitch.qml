import QtQuick

Rectangle {
    id: root

    property bool checked: false
    property bool animationsEnabled: true
    property real animationSpeed: 1
    property real uiScale: 1

    implicitWidth: 52 * uiScale
    implicitHeight: 32 * uiScale
    radius: height / 2
    color: checked ? "#6750a4" : "#e6e0e9"
    border.width: checked ? 0 : 2 * uiScale
    border.color: "#79747e"

    Behavior on color {
        enabled: root.animationsEnabled
        ColorAnimation { duration: 180 / Math.max(root.animationSpeed, 0.1) }
    }

    Rectangle {
        id: thumb

        width: (root.checked ? 24 : 16) * root.uiScale
        height: width
        radius: width / 2
        x: root.checked ? root.width - 28 * root.uiScale : 6 * root.uiScale
        anchors.verticalCenter: parent.verticalCenter
        color: root.checked ? "white" : "#79747e"

        Behavior on width {
            enabled: root.animationsEnabled
            NumberAnimation { duration: 180 / Math.max(root.animationSpeed, 0.1); easing.type: Easing.OutCubic }
        }
        Behavior on x {
            enabled: root.animationsEnabled
            NumberAnimation { duration: 180 / Math.max(root.animationSpeed, 0.1); easing.type: Easing.OutCubic }
        }
        Behavior on color {
            enabled: root.animationsEnabled
            ColorAnimation { duration: 180 / Math.max(root.animationSpeed, 0.1) }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.checked = !root.checked
    }
}
