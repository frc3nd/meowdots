import Quickshell
import QtQuick
import "../../../components" as Ui
import ".." as Settings
import "../../../services" as Services

FloatingWindow {
    id: root

    signal closeRequested()
    property string desktopName: ""
    property string language: "ru"
    property var appearance: null

    title: "meowdots — " + localization.text("windowTitle")
    implicitWidth: 820
    implicitHeight: 510
    color: "transparent"

    onClosed: closeRequested()

    Services.Localization {
        id: localization
        localesDir: Qt.resolvedUrl("../locales")
        language: root.language
    }

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
        language: root.language
        appearance: root.appearance
    }
}
