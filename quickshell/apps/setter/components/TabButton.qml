import QtQuick
import QtQuick.Controls
import "." as Ui

Item {
    id: button

    required property string tab
    required property string label
    property bool selected: false
    property bool expanded: true
    property bool revealText: true
    property bool animate: true
    property bool animateText: true
    property real visibleLetters: revealText ? label.length : 0
    signal clicked()

    height: 38
    clip: true

    Behavior on visibleLetters {
        enabled: button.animateText
        NumberAnimation { duration: 260; easing.type: Easing.Linear }
    }

    Ui.TabIcon {
        id: icon
        name: button.tab
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: 40
        height: parent.height
        color: button.selected ? "#cba6f7" : "#a6adc8"
        Behavior on color {
            enabled: button.animate
            ColorAnimation { duration: 180 }
        }
    }

    Text {
        anchors.left: icon.right
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        text: button.label.slice(0, Math.floor(button.visibleLetters))
        color: button.selected ? "#cba6f7" : "#a6adc8"
        font.bold: button.selected
        elide: Text.ElideRight
        Behavior on color {
            enabled: button.animate
            ColorAnimation { duration: 180 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: !button.expanded
        ToolTip.visible: containsMouse && !button.expanded
        ToolTip.text: button.label
        onClicked: button.clicked()
    }
}
