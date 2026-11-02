import QtQuick
import QtQuick.Layouts

Item {
    id: control

    required property string label
    required property bool checked
    property bool animate: true
    signal toggled()

    Layout.fillWidth: true
    Layout.preferredHeight: 44

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        text: control.label
        color: "#cdd6f4"
    }

    Rectangle {
        id: track
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.verticalCenter: parent.verticalCenter
        width: 40
        height: 22
        radius: height / 2
        color: control.checked ? "#cba6f7" : "#45475a"
        Behavior on color {
            enabled: control.animate
            ColorAnimation { duration: 160 }
        }

        Rectangle {
            width: 16
            height: 16
            y: 3
            x: control.checked ? track.width - width - 3 : 3
            radius: height / 2
            color: "#11111b"

            Behavior on x {
                enabled: control.animate
                NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: control.toggled()
    }
}
