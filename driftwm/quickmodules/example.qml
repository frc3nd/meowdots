import Quickshell
import QtQuick
import QtQuick.Controls

FloatingWindow {
    id: example

    signal closeRequested()

    title: "meowdots example"
    implicitWidth: 320
    implicitHeight: 180
    color: "#1e1e2e"

    property bool wasVisible: false

    onVisibleChanged: {
        if (visible) wasVisible = true
        else if (wasVisible) closeRequested()
    }

    Text {
        anchors.centerIn: parent
        text: "пример модуля"
        color: "#cdd6f4"
        font.pixelSize: 18
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16
        text: "закрыть"
        onClicked: example.visible = false
    }
}
