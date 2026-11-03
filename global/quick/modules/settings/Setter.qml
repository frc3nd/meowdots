import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../../components" as Ui
import "../../services" as Services

Item {
    id: root

    required property string desktopName
    property string language: "ru"
    property var appearance: null
    property string currentTab: ""

    FileView {
        id: mapFile
        path: Qt.resolvedUrl("map.json")
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var registry: {
        try { return JSON.parse(mapFile.text()) }
        catch (error) { return {} }
    }
    readonly property string desktopPath: registry.desktops
        && typeof registry.desktops[desktopName] === "string"
        ? registry.desktops[desktopName] : ""

    FileView {
        id: desktopFile
        path: root.desktopPath ? Qt.resolvedUrl(root.desktopPath) : ""
        blockLoading: true
        printErrors: false
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var descriptor: {
        try { return JSON.parse(desktopFile.text()) }
        catch (error) { return {} }
    }
    readonly property string desktopView: descriptor && descriptor.id === desktopName
        && descriptor.settings && typeof descriptor.settings.view === "string"
        && /^quick\/[a-zA-Z0-9_/-]+\.qml$/.test(descriptor.settings.view)
        ? descriptor.settings.view : ""

    Services.Localization {
        id: localization
        localesDir: Qt.resolvedUrl("locales")
        language: root.language
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Ui.Sidebar {
            Layout.fillHeight: true
            tabs: desktopPage.item ? desktopPage.item.tabs : []
            currentTab: root.currentTab
            labelFor: key => localization.text(key)
            animationsEnabled: root.appearance ? root.appearance.animationsEnabled : true
            animationSpeed: root.appearance ? root.appearance.animationSpeed : 1
            onTabSelected: tab => root.currentTab = tab
        }

        Ui.TileCanvas {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: desktopPage
                anchors.fill: parent
                source: root.desktopView
                    ? Qt.resolvedUrl(root.desktopPath.substring(0, root.desktopPath.lastIndexOf("/") + 1) + root.desktopView)
                    : ""
                onLoaded: root.currentTab = item.tabs[0] || ""
            }

            Binding {
                target: desktopPage.item
                property: "currentTab"
                value: root.currentTab
                when: desktopPage.item !== null
            }

            Text {
                anchors.centerIn: parent
                visible: !desktopPage.item && desktopPage.status !== Loader.Loading
                text: localization.text("unsupportedDesktop")
                    .replace("%1", root.desktopName || "?")
                color: "white"
            }
        }
    }
}
