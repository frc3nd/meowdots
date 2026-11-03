import QtQuick

Rectangle {
    property bool animationsEnabled: true

    color: "#e61e1e2e"

    Behavior on color {
        enabled: animationsEnabled
        ColorAnimation {
            duration: 400
            easing.type: Easing.InOutCubic
        }
    }
}
