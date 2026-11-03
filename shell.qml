import Quickshell
import QtQuick

ShellRoot {
    readonly property string desktopName: (Quickshell.env("XDG_CURRENT_DESKTOP") || "")
        .split(":")[0].toLowerCase()

    Component.onCompleted: console.log("[meowdots] desktop:", desktopName)
}
