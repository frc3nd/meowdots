import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "." as Ui

Rectangle {
    id: sidebar

    required property string currentTab
    required property bool expanded
    required property bool animateTabs
    required property bool animateSidebar
    required property bool animationReady
    required property real cornerRadius
    required property var labelFor

    signal tabSelected(string tab)
    signal expansionToggled()

    property bool visualExpanded: expanded
    property bool labelsExpanded: expanded
    property real sidebarWidth: visualExpanded ? 190 : 56
    property string previousTab: "main"
    property bool motionReady: false
    property bool animateExpansion: false
    readonly property real tabHeight: 38
    readonly property real tabSpacing: 6
    readonly property real targetY: currentTab === "main"
        ? topTabs.y : bottomTabs.y + (currentTab === "console" ? 0 : tabHeight + tabSpacing)
    readonly property real gapCenter: (topTabs.y + topTabs.height + bottomTabs.y) / 2

    Layout.preferredWidth: sidebarWidth
    Layout.fillHeight: true
    color: "#181825"

    Behavior on sidebarWidth {
        enabled: sidebar.animateExpansion && sidebar.animationReady && sidebar.animateSidebar
        NumberAnimation { duration: 200; easing.type: Easing.InOutCubic }
    }

    onExpandedChanged: {
        openLabels.stop()
        closeSidebar.stop()
        if (!animateExpansion || !animationReady || !animateSidebar) {
            visualExpanded = expanded
            labelsExpanded = expanded
        } else if (expanded) {
            visualExpanded = true
            openLabels.start()
        } else {
            labelsExpanded = false
            closeSidebar.start()
        }
    }

    onAnimateSidebarChanged: {
        if (animateSidebar) return
        openLabels.stop()
        closeSidebar.stop()
        visualExpanded = expanded
        labelsExpanded = expanded
    }

    Timer {
        id: openLabels
        interval: 200
        onTriggered: sidebar.labelsExpanded = true
    }

    Timer {
        id: closeSidebar
        interval: 260
        onTriggered: sidebar.visualExpanded = false
    }

    // Wait one event loop after preferences load so the saved width is applied without animation.
    Timer {
        interval: 0
        running: sidebar.animationReady
        onTriggered: sidebar.animateExpansion = true
    }

    Component.onCompleted: {
        previousTab = currentTab
        indicator.y = targetY
        motionReady = true
    }

    onHeightChanged: {
        if (!sameZoneMove.running && !crossZoneMove.running)
            indicator.y = targetY
    }

    onCurrentTabChanged: {
        if (!motionReady) return
        const sameZone = (previousTab === "main") === (currentTab === "main")
        previousTab = currentTab
        sameZoneMove.stop()
        crossZoneMove.stop()

        if (!animateTabs) {
            indicator.y = targetY
            indicator.opacity = 1
        } else if (sameZone) {
            sameZoneMove.start()
        } else {
            crossZoneMove.start()
        }
    }

    onAnimateTabsChanged: {
        if (animateTabs || !motionReady) return
        sameZoneMove.stop()
        crossZoneMove.stop()
        indicator.y = targetY
        indicator.opacity = 1
    }

    ParallelAnimation {
        id: sameZoneMove
        NumberAnimation {
            target: indicator
            property: "y"
            to: sidebar.targetY
            duration: 220
            easing.type: Easing.InOutCubic
        }
        NumberAnimation { target: indicator; property: "opacity"; to: 1; duration: 150 }
    }

    SequentialAnimation {
        id: crossZoneMove
        ParallelAnimation {
            NumberAnimation {
                target: indicator
                property: "y"
                to: sidebar.gapCenter
                duration: 170
                easing.type: Easing.InCubic
            }
            NumberAnimation { target: indicator; property: "opacity"; to: 0; duration: 170 }
        }
        ParallelAnimation {
            NumberAnimation {
                target: indicator
                property: "y"
                to: sidebar.targetY
                duration: 170
                easing.type: Easing.OutCubic
            }
            NumberAnimation { target: indicator; property: "opacity"; to: 1; duration: 170 }
        }
    }

    Text {
        anchors.left: parent.left
        anchors.leftMargin: 22
        anchors.top: parent.top
        anchors.topMargin: 18
        text: "meowdots"
        color: "#cdd6f4"
        font.bold: true
        font.pixelSize: 17
        visible: sidebar.visualExpanded
    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 12
        width: 32
        height: 32
        radius: sidebar.cornerRadius
        color: "#313244"
        z: 2

        Ui.TabIcon {
            anchors.centerIn: parent
            name: sidebar.expanded ? "collapse" : "expand"
            color: "#cdd6f4"
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            ToolTip.visible: containsMouse
            ToolTip.text: sidebar.labelFor(sidebar.expanded ? "collapseSidebar" : "expandSidebar")
            onClicked: sidebar.expansionToggled()
        }
    }

    Ui.TabIndicator {
        id: indicator
        x: sidebar.visualExpanded ? 12 : 8
        y: topTabs.y
        width: sidebar.width - (sidebar.visualExpanded ? 24 : 16)
        height: sidebar.tabHeight
        cornerRadius: sidebar.cornerRadius
    }

    Column {
        id: topTabs
        x: sidebar.visualExpanded ? 12 : 8
        y: 62
        z: 1
        width: sidebar.width - (sidebar.visualExpanded ? 24 : 16)
        spacing: sidebar.tabSpacing

        Ui.TabButton {
            width: parent.width
            tab: "main"
            label: sidebar.labelFor("main")
            selected: sidebar.currentTab === tab
            expanded: sidebar.visualExpanded
            revealText: sidebar.labelsExpanded
            animateText: sidebar.animateSidebar && sidebar.animationReady && sidebar.animateExpansion
            animate: sidebar.animateTabs
            onClicked: sidebar.tabSelected(tab)
        }
    }

    Column {
        id: bottomTabs
        x: sidebar.visualExpanded ? 12 : 8
        y: sidebar.height - height - 12
        z: 1
        width: sidebar.width - (sidebar.visualExpanded ? 24 : 16)
        spacing: sidebar.tabSpacing

        Ui.TabButton {
            width: parent.width
            tab: "console"
            label: sidebar.labelFor("console")
            selected: sidebar.currentTab === tab
            expanded: sidebar.visualExpanded
            revealText: sidebar.labelsExpanded
            animateText: sidebar.animateSidebar && sidebar.animationReady && sidebar.animateExpansion
            animate: sidebar.animateTabs
            onClicked: sidebar.tabSelected(tab)
        }
        Ui.TabButton {
            width: parent.width
            tab: "setter"
            label: sidebar.labelFor("setter")
            selected: sidebar.currentTab === tab
            expanded: sidebar.visualExpanded
            revealText: sidebar.labelsExpanded
            animateText: sidebar.animateSidebar && sidebar.animationReady && sidebar.animateExpansion
            animate: sidebar.animateTabs
            onClicked: sidebar.tabSelected(tab)
        }
    }
}
