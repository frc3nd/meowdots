import Quickshell
import QtQuick
import "../../../components" as Ui
import ".." as Settings

FloatingWindow {
    id: root

    signal closeRequested()
    property string desktopName: ""
    property var appearance: null

    title: "meowdots settings"
    implicitWidth: 820
    implicitHeight: 510
    color: "transparent"

    onClosed: closeRequested()

    Ui.Background {
        anchors.fill: parent
        animationsEnabled: root.appearance ? root.appearance.animationsEnabled : true
        transparencyEnabled: root.appearance ? root.appearance.transparencyEnabled : true
        animationSpeed: root.appearance ? root.appearance.animationSpeed : 1
        surfaceOpacity: root.appearance ? root.appearance.surfaceOpacity : 0.9
    }

    Settings.Setter {
        anchors.fill: parent
        desktopName: root.desktopName
    }
}
