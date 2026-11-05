import QtQuick
import "." as Parts

Rectangle {
    id: root

    property var tabs: []
    property string currentTab: ""
    property var labelFor: key => key
    property bool collapsed: false
    property bool animationsEnabled: true
    property real animationSpeed: 1
    property real uiScale: 1
    readonly property real expandedWidth: 208 * uiScale
    readonly property real collapsedWidth: 56 * uiScale

    signal tabSelected(string tab)

    implicitWidth: collapsed ? collapsedWidth : expandedWidth
    color: "#282838"

    Behavior on implicitWidth {
        enabled: root.animationsEnabled
        NumberAnimation {
            duration: 240 / Math.max(root.animationSpeed, 0.1)
            easing.type: Easing.InOutCubic
        }
    }

    Parts.SidebarBrand {
        id: brand
        width: parent.width
        uiScale: root.uiScale
    }

    Rectangle {
        id: divider
        anchors.top: brand.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12 * root.uiScale
        anchors.rightMargin: 12 * root.uiScale
        height: Math.max(1, root.uiScale)
        color: "#60607a"
    }

    Column {
        id: mainTabs
        anchors.top: divider.bottom
        anchors.topMargin: 12 * root.uiScale
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10 * root.uiScale
        anchors.rightMargin: 10 * root.uiScale
        spacing: 8 * root.uiScale

        Repeater {
            model: root.tabs

            Parts.SidebarTab {
                required property var modelData
                width: mainTabs.width
                tabId: modelData.id
                icon: modelData.icon
                label: root.labelFor(modelData.id)
                selected: root.currentTab === modelData.id
                animationsEnabled: root.animationsEnabled
                uiScale: root.uiScale
                onClicked: tabId => root.tabSelected(tabId)
            }
        }
    }

    Column {
        id: utilityTabs
        anchors.left: mainTabs.left
        anchors.right: mainTabs.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16 * root.uiScale
        spacing: 8 * root.uiScale

        Repeater {
            model: [
                { id: "settings", icon: "⚙" },
                { id: "console", icon: ">_" }
            ]

            Parts.SidebarTab {
                required property var modelData
                width: utilityTabs.width
                tabId: modelData.id
                icon: modelData.icon
                label: root.labelFor(modelData.id)
                selected: root.currentTab === modelData.id
                animationsEnabled: root.animationsEnabled
                uiScale: root.uiScale
                onClicked: tabId => root.tabSelected(tabId)
            }
        }
    }

    Parts.SidebarHandle {
        anchors.right: parent.right
        anchors.rightMargin: -8 * root.uiScale
        anchors.verticalCenter: parent.verticalCenter
        z: 1
        collapsed: root.collapsed
        uiScale: root.uiScale
        collapseProgress: Math.max(0, Math.min(1,
            (root.expandedWidth - root.width) / (root.expandedWidth - root.collapsedWidth)))
        onToggled: root.collapsed = !root.collapsed
    }
}
