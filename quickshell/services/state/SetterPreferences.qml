import Quickshell
import Quickshell.Io

Scope {
    id: preferences

    property bool animations: true
    property bool tabs: true
    property bool sidebar: true
    property bool switches: true
    property bool content: true
    property bool sidebarExpanded: true
    property bool ready: false

    FileView {
        id: file
        path: ""
        blockLoading: true
        printErrors: false
        watchChanges: true

        onFileChanged: reload()
        onLoaded: preferences.load()
        onLoadFailed: preferences.ready = true
        onSaveFailed: error => console.warn("[meowdots] setter | cannot save preferences: " + error)
    }

    Process {
        command: ["mkdir", "-p", Quickshell.stateDir]
        running: true

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) file.path = Quickshell.statePath("setter.json")
            else console.warn("[meowdots] setter | cannot create state directory")
        }
    }

    function load(): void {
        try {
            const data = JSON.parse(file.text())
            ready = false
            animations = data.animations !== false
            tabs = data.tabs !== false
            sidebar = data.sidebar !== false
            switches = data.switches !== false
            content = data.content !== false
            sidebarExpanded = data.sidebarExpanded !== false
        } catch (error) {
            console.warn("[meowdots] setter | invalid preferences: " + error)
        }
        ready = true
    }

    function save(): void {
        if (!ready) return
        file.setText(JSON.stringify({ animations, tabs, sidebar, switches, content, sidebarExpanded }, null, 2) + "\n")
    }

    onAnimationsChanged: save()
    onTabsChanged: save()
    onSidebarChanged: save()
    onSwitchesChanged: save()
    onContentChanged: save()
    onSidebarExpandedChanged: save()
}
