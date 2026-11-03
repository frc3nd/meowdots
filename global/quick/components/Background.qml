import QtQuick

Rectangle {
    id: root

    property bool animationsEnabled: true
    property bool transparencyEnabled: true
    property real animationSpeed: 1
    property real surfaceOpacity: 0.9

    color: "#1e1e2e"
    opacity: transparencyEnabled ? surfaceOpacity : 1

    Behavior on color {
        enabled: root.animationsEnabled
        ColorAnimation {
            duration: 400 / Math.max(root.animationSpeed, 0.1)
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on opacity {
        enabled: root.animationsEnabled
        NumberAnimation {
            duration: 400 / Math.max(root.animationSpeed, 0.1)
            easing.type: Easing.InOutCubic
        }
    }
}
