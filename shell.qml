import Quickshell
import Quickshell.Io
import QtQuick
import "global/quick/services" as Services

ShellRoot {
    id: root

    readonly property string desktopName: (Quickshell.env("XDG_CURRENT_DESKTOP") || "")
        .split(":")[0].toLowerCase()

    Component.onCompleted: console.log("[meowdots] desktop:", desktopName)

    Services.Appearance { id: appearance }

    Loader {
        id: settingsLoader
        active: false
        source: Qt.resolvedUrl("global/quick/modules/settings/app/app.qml")
        onLoaded: {
            item.desktopName = root.desktopName
            item.appearance = appearance
        }
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
