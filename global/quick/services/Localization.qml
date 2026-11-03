import Quickshell.Io
import QtQuick

Item {
    id: root

    property url localesDir
    property string language: "ru"
    property var russian: ({})
    property var selected: ({})

    function text(key: string): string {
        return selected[key] || russian[key] || key
    }

    function parse(file: FileView): var {
        try {
            const data = JSON.parse(file.text())
            return data && typeof data === "object" && !Array.isArray(data) ? data : {}
        } catch (error) {
            return {}
        }
    }

    FileView {
        id: fallback
        path: root.localesDir + "/ru.json"
        blockLoading: true
        printErrors: false
        watchChanges: true
        onLoaded: root.russian = root.parse(fallback)
        onLoadFailed: root.russian = ({})
        onFileChanged: reload()
    }

    FileView {
        id: current
        path: root.localesDir + "/" + (/^[a-zA-Z0-9_-]+$/.test(root.language) ? root.language : "ru") + ".json"
        blockLoading: true
        printErrors: false
        watchChanges: true
        onPathChanged: root.selected = ({})
        onLoaded: root.selected = root.parse(current)
        onLoadFailed: root.selected = ({})
        onFileChanged: reload()
    }
}
