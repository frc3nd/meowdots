import Quickshell
import Quickshell.Io
import QtQuick

ShellRoot {
    id: root

    readonly property string wm: (Quickshell.env("XDG_CURRENT_DESKTOP") || "")
        .split(":")[0].toLowerCase()

    FileView {
        id: stateFile
        path: Qt.resolvedUrl("quickshell/state.json")
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var state: {
        try {
            return JSON.parse(stateFile.text())
        } catch (error) {
            console.warn("[meowdots] root | cannot read state.json: " + error)
            return {}
        }
    }

    readonly property var enabledModules: {
        const modules = state[wm]?.enabled_modules
        if (!Array.isArray(modules)) return []

        return [...new Set(modules.filter(name =>
            typeof name === "string" && /^[a-z0-9_-]+\.qml$/.test(name)))]
    }

    Variants {
        id: moduleVariants
        model: root.enabledModules

        delegate: Scope {
            id: moduleScope
            required property string modelData
            property bool launched: true

            readonly property string modulePath: root.wm + "/quickmodules/" + modelData

            LazyLoader {
                id: moduleLoader
                source: Qt.resolvedUrl(moduleScope.modulePath)
                active: moduleScope.launched

                onItemChanged: {
                    if (item) console.log("[meowdots] " + moduleScope.modulePath + " | opened")
                }
            }

            Connections {
                target: moduleLoader.item

                function onCloseRequested() {
                    if (!moduleScope.launched) return
                    moduleScope.launched = false
                    console.log("[meowdots] " + moduleScope.modulePath + " | closed")
                }
            }
        }
    }

    IpcHandler {
        target: "modules"

        function toggle(name: string): void {
            for (let index = 0; index < moduleVariants.instances.length; index++) {
                const module = moduleVariants.instances[index]
                if (module.modelData !== name) continue

                if (module.launched) {
                    module.launched = false
                    console.log("[meowdots] " + module.modulePath + " | closed")
                } else {
                    module.launched = true
                }
                return
            }

            console.warn("[meowdots] root | module is not enabled: " + name)
        }
    }

    LazyLoader {
        id: settingsLoader
        source: Qt.resolvedUrl("quickshell/services/settings/shell.qml")
    }

    function closeSettings(): void {
        if (!settingsLoader.active) return
        settingsLoader.active = false
        console.log("[meowdots] setter | closed")
    }

    Connections {
        target: settingsLoader.item

        function onCloseRequested() { root.closeSettings() }
    }

    IpcHandler {
        target: "settings"

        function open(): void {
            const wasOpen = settingsLoader.active
            settingsLoader.active = true
            settingsLoader.item.visible = true
            if (!wasOpen) console.log("[meowdots] setter | opened")
        }

        function close(): void { root.closeSettings() }
    }

    Component.onCompleted: console.log("[meowdots] root | wm: " + (wm || "unknown"))
}
