import Quickshell
import Quickshell.Io
import QtQuick

Scope {
    id: adapter

    property int attempts: 0
    property bool pending: false

    function focusSetter(): void {
        attempts = 0
        pending = true
        retry.restart()
    }

    function cancel(): void {
        pending = false
        retry.stop()
    }

    function findSetter(output: string): void {
        if (!pending) return
        try {
            const state = JSON.parse(output).Ok.State
            const window = state.windows.find(item =>
                item.pid === Quickshell.processId && item.title.startsWith("meowdots — "))

            if (window) {
                pending = false
                focus.exec(["driftwm", "msg", "focus", "--id", String(window.id)])
                return
            }
        } catch (error) {
            console.warn("[meowdots] driftwm | cannot find setter: " + error)
            return
        }

        if (attempts < 3) retry.restart()
        else {
            pending = false
            console.warn("[meowdots] driftwm | setter window was not found")
        }
    }

    Timer {
        id: retry
        interval: 120
        onTriggered: {
            adapter.attempts++
            lookup.running = true
        }
    }

    Process {
        id: lookup
        command: ["driftwm", "msg", "--json", "state"]
        stdout: StdioCollector { onStreamFinished: adapter.findSetter(this.text) }
    }

    Process { id: focus }
}
