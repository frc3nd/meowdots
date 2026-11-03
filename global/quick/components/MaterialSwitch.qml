import QtQuick

Rectangle {
    id: root

    property bool checked: false
    property bool animationsEnabled: true

    implicitWidth: 52
    implicitHeight: 32
    radius: height / 2
    color: checked ? "#6750a4" : "#e6e0e9"
    border.width: checked ? 0 : 2
    border.color: "#79747e"

    Behavior on color {
        enabled: root.animationsEnabled
        ColorAnimation { duration: 180 }
    }

    Rectangle {
        id: thumb

        width: root.checked ? 24 : 16
        height: width
        radius: width / 2
        x: root.checked ? root.width - 28 : 6
        anchors.verticalCenter: parent.verticalCenter
        color: root.checked ? "white" : "#79747e"

        Behavior on width {
            enabled: root.animationsEnabled
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on x {
            enabled: root.animationsEnabled
            NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
        }
        Behavior on color {
            enabled: root.animationsEnabled
            ColorAnimation { duration: 180 }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.checked = !root.checked
    }
}
