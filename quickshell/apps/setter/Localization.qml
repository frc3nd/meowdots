import Quickshell.Io
import QtQuick
import Qt.labs.folderlistmodel

Item {
    id: localization

    property string language: "ru"
    property var russian: ({})
    property var selected: ({})
    property alias languages: files

    function text(key: string): string {
        return selected[key] || russian[key] || key
    }

    function parse(file: FileView): var {
        try {
            const data = JSON.parse(file.text())
            return data && typeof data === "object" && !Array.isArray(data) ? data : {}
        } catch (error) {
            console.warn("[meowdots] setter | invalid locale: " + error)
            return {}
        }
    }

    FolderListModel {
        id: files
        folder: Qt.resolvedUrl("locales")
        nameFilters: ["*.json"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    FileView {
        id: fallback
        path: Qt.resolvedUrl("locales/ru.json")
        blockLoading: true
        watchChanges: true
        onLoaded: localization.russian = localization.parse(fallback)
        onFileChanged: reload()
    }

    FileView {
        id: current
        path: Qt.resolvedUrl("locales/" + localization.language + ".json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onPathChanged: localization.selected = ({})
        onLoaded: localization.selected = localization.parse(current)
        onLoadFailed: localization.selected = ({})
        onFileChanged: reload()
    }
}
