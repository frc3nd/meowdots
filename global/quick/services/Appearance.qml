import Quickshell
import Quickshell.Io

Scope {
    id: root

    FileView {
        id: profileFile
        path: Qt.resolvedUrl("../../profiles/default/profile.json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var profile: {
        try { return JSON.parse(profileFile.text()) }
        catch (error) { return {} }
    }
    readonly property string themeName: typeof profile.theme === "string"
        && /^[a-z0-9_-]+$/.test(profile.theme) ? profile.theme : "default"

    FileView {
        id: themeFile
        path: Qt.resolvedUrl("../../themes/" + root.themeName + "/theme.json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var theme: {
        try { return JSON.parse(themeFile.text()) }
        catch (error) { return {} }
    }

    readonly property bool animationsEnabled: typeof profile.animations === "boolean"
        ? profile.animations : true
    readonly property bool transparencyEnabled: typeof profile.transparency === "boolean"
        ? profile.transparency : true
    readonly property real animationSpeed: typeof theme.animation_speed === "number"
        && isFinite(theme.animation_speed) && theme.animation_speed > 0
        ? theme.animation_speed : 1
    readonly property real surfaceOpacity: typeof theme.surface_opacity === "number"
        && isFinite(theme.surface_opacity)
        ? Math.max(0, Math.min(1, theme.surface_opacity)) : 0.9
}
