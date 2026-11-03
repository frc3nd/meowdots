import Quickshell
import QtQuick
import "../../../components" as Ui

FloatingWindow {
    signal closeRequested()

    title: "meowdots settings"
    implicitWidth: 820
    implicitHeight: 510
    color: "transparent"

    onClosed: closeRequested()

    Ui.Background {
        anchors.fill: parent
    }
}
