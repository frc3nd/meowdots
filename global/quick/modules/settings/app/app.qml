import Quickshell
import QtQuick
import "../../../components" as Ui
import ".." as Settings

FloatingWindow {
    id: root

    signal closeRequested()
    property string desktopName: ""

    title: "meowdots settings"
    implicitWidth: 820
    implicitHeight: 510
    color: "transparent"

    onClosed: closeRequested()

    Ui.Background {
        anchors.fill: parent
    }

    Settings.Setter {
        anchors.fill: parent
        desktopName: root.desktopName
    }
}
