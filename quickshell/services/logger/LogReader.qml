import Quickshell
import Quickshell.Io

Scope {
    id: logger

    property string history: ""

    FileView {
        id: filtersFile
        path: Qt.resolvedUrl("ignored.json")
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var ignored: {
        try {
            const data = JSON.parse(filtersFile.text())
            return Array.isArray(data.contains) ? data.contains : []
        } catch (error) {
            console.warn("[meowdots] logger | invalid ignored.json: " + error)
            return []
        }
    }

    function addLine(line: string): void {
        const clean = line.replace(/\x1b\[[0-9;]*[a-zA-Z]/g, "")
        if (ignored.some(fragment => clean.includes(fragment))) return

        history = (history + clean + "\n").split("\n").slice(-401).join("\n")
    }

    Process {
        command: ["qs", "log", "--pid", String(Quickshell.processId), "--tail", "200", "--follow"]
        running: true
        stdout: SplitParser { onRead: line => logger.addLine(line) }
        stderr: SplitParser {
            onRead: line => logger.addLine("[meowdots] logger | " + line)
        }
    }
}
