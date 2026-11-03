import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    readonly property string desktopName: (Quickshell.env("XDG_CURRENT_DESKTOP") || "")
        .split(":")[0].toLowerCase()

    Component.onCompleted: console.log("[meowdots] desktop:", desktopName)

    Loader {
        id: settingsLoader
        active: false
        source: Qt.resolvedUrl("global/quick/modules/settings/app/app.qml")
        onLoaded: item.desktopName = root.desktopName
    }

    Connections {
        target: settingsLoader.item
        function onCloseRequested() { settingsLoader.active = false }
    }

    IpcHandler {
        target: "settings"
        function open() { settingsLoader.active = true }
    }
}
