import Quickshell
import Quickshell.Io
import QtQuick
import "global/quick/services" as Services

ShellRoot {
    id: root

    readonly property string desktopName: (Quickshell.env("XDG_CURRENT_DESKTOP") || "")
        .split(":")[0].toLowerCase()

    FileView {
        id: stateFile
        path: Qt.resolvedUrl("global/quick/state.json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var state: {
        try { return JSON.parse(stateFile.text()) }
        catch (error) { return {} }
    }
    readonly property string language: typeof state.language === "string"
        && /^[a-zA-Z0-9_-]+$/.test(state.language) ? state.language : "ru"

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

    Binding {
        target: settingsLoader.item
        property: "language"
        value: root.language
        when: settingsLoader.item !== null
    }

    IpcHandler {
        target: "settings"
        function open() { settingsLoader.active = true }
    }
}
