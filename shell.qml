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
        onSaveFailed: error => console.warn("[meowdots] root | cannot save state.json: " + error)
    }

    readonly property var state: {
        try {
            return JSON.parse(stateFile.text())
        } catch (error) {
            console.warn("[meowdots] root | cannot read state.json: " + error)
            return {}
        }
    }

    readonly property string language: typeof state.language === "string"
        && /^[a-zA-Z0-9_-]+$/.test(state.language) ? state.language : "ru"
    readonly property string globalTheme: typeof state.global_theme === "string"
        && /^[a-z0-9_-]+$/.test(state.global_theme) ? state.global_theme : "default"

    function setLanguage(language: string): void {
        if (language === root.language || !/^[a-zA-Z0-9_-]+$/.test(language)) return
        const updated = Object.assign({}, root.state)
        updated.language = language
        stateFile.setText(JSON.stringify(updated, null, 2) + "\n")
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
        source: Qt.resolvedUrl("quickshell/apps/setter/setter.qml")
    }

    Binding {
        target: settingsLoader.item
        property: "language"
        value: root.language
        when: settingsLoader.item !== null
    }

    Binding {
        target: settingsLoader.item
        property: "themeName"
        value: root.globalTheme
        when: settingsLoader.item !== null
    }

    Binding {
        target: settingsLoader.item
        property: "currentDesktop"
        value: root.wm
        when: settingsLoader.item !== null
    }

    function closeSettings(): void {
        if (!settingsLoader.active) return
        settingsLoader.active = false
        console.log("[meowdots] setter | closed")
    }

    Connections {
        target: settingsLoader.item

        function onCloseRequested() { root.closeSettings() }
        function onLanguageSelected(language) { root.setLanguage(language) }
    }

    IpcHandler {
        target: "settings"

        function open(): void {
            const wasOpen = settingsLoader.active
            settingsLoader.active = true
            if (!settingsLoader.item) {
                console.error("[meowdots] setter | failed to load")
                settingsLoader.active = false
                return
            }
            settingsLoader.item.visible = true
            if (!wasOpen) console.log("[meowdots] setter | opened")
        }

        function close(): void { root.closeSettings() }

        function setLanguage(language: string): void { root.setLanguage(language) }

        function toggle(): void {
            if (settingsLoader.active) root.closeSettings()
            else open()
        }
    }

    Component.onCompleted: console.log("[meowdots] root | wm: " + (wm || "unknown"))
}
