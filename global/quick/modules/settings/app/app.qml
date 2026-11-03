import Quickshell
import QtQuick

FloatingWindow {
    signal closeRequested()

    title: "meowdots settings"
    implicitWidth: 820
    implicitHeight: 510
    color: "#1e1e2e"

    onClosed: closeRequested()
}
