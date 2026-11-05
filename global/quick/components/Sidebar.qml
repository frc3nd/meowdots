import QtQuick

Rectangle {
    id: root

    property bool collapsed: false
    property bool animationsEnabled: true
    property real animationSpeed: 1
    property real uiScale: 1

    implicitWidth: (collapsed ? 56 : 190) * uiScale
    color: "#282838"

    Behavior on implicitWidth {
        enabled: root.animationsEnabled
        NumberAnimation {
            duration: 240 / Math.max(root.animationSpeed, 0.1)
            easing.type: Easing.InOutCubic
        }
    }
}
