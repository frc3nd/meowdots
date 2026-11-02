import Quickshell
import Quickshell.Io

Scope {
    id: theme

    property string themeName: "default"
    property real cornerRadius: 12

    FileView {
        id: file
        path: Qt.resolvedUrl("../../../themes/" + theme.themeName + "/theme.json")
        blockLoading: true
        printErrors: false
        watchChanges: true

        onPathChanged: theme.cornerRadius = 12
        onFileChanged: reload()
        onLoaded: {
            try {
                const value = JSON.parse(text()).corner_radius
                theme.cornerRadius = typeof value === "number" && isFinite(value) && value >= 0
                    ? value : 12
            } catch (error) {
                console.warn("[meowdots] theme | invalid theme.json: " + error)
                theme.cornerRadius = 12
            }
        }
        onLoadFailed: theme.cornerRadius = 12
    }
}
