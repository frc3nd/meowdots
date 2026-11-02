import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../services/logger" as Logs
import "../../services/state" as State
import "i18n.js" as I18n

FloatingWindow {
    id: settings

    signal closeRequested()

    title: labelFor("windowTitle")
    implicitWidth: 820
    implicitHeight: 510
    color: "#1e1e2e"

    property string language: "ru"
    property string currentTab: "main"
    property bool wasVisible: false

    // DriftWM rounds the outer window itself. Keep this separate for other WMs.
    property real windowRadius: 12
    property real elementRadius: 12
    property bool separateRadii: true
    readonly property real innerRadius: separateRadii ? elementRadius : windowRadius

    readonly property real tabHeight: 38
    readonly property real tabSpacing: 6
    readonly property bool tabMotion: preferences.animations && preferences.tabs
    readonly property bool topTabActive: currentTab === "main"
    readonly property real targetIndicatorY: topTabActive
        ? topTabs.y
        : bottomTabs.y + (currentTab === "console" ? 0 : tabHeight + tabSpacing)
    readonly property real gapCenter: (topTabs.y + topTabs.height + bottomTabs.y) / 2

    function labelFor(key: string): string {
        return I18n.text(language, key)
    }

    function selectTab(key: string): void {
        if (key === currentTab) return
        const sameZone = (currentTab === "main") === (key === "main")
        sameZoneMove.stop()
        crossZoneMove.stop()
        currentTab = key

        if (!tabMotion) {
            indicator.y = targetIndicatorY
            indicator.opacity = 1
        } else if (sameZone) {
            sameZoneMove.start()
        } else {
            crossZoneMove.start()
        }
    }

    onTabMotionChanged: {
        if (tabMotion) return
        sameZoneMove.stop()
        crossZoneMove.stop()
        indicator.y = targetIndicatorY
        indicator.opacity = 1
    }

    onVisibleChanged: {
        if (visible) wasVisible = true
        else if (wasVisible) closeRequested()
    }

    State.SetterPreferences { id: preferences }
    Logs.LogReader { id: logger }

    ParallelAnimation {
        id: sameZoneMove
        NumberAnimation {
            target: indicator
            property: "y"
            to: settings.targetIndicatorY
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
                to: settings.gapCenter
                duration: 170
                easing.type: Easing.InCubic
            }
            NumberAnimation { target: indicator; property: "opacity"; to: 0; duration: 170 }
        }
        ParallelAnimation {
            NumberAnimation {
                target: indicator
                property: "y"
                to: settings.targetIndicatorY
                duration: 170
                easing.type: Easing.OutCubic
            }
            NumberAnimation { target: indicator; property: "opacity"; to: 1; duration: 170 }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: sidebar
            Layout.preferredWidth: 190
            Layout.fillHeight: true
            color: "#181825"

            onHeightChanged: {
                if (!sameZoneMove.running && !crossZoneMove.running)
                    indicator.y = settings.targetIndicatorY
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
            }

            Rectangle {
                id: indicator
                x: 12
                y: topTabs.y
                z: 0
                width: sidebar.width - 24
                height: settings.tabHeight
                radius: settings.innerRadius
                color: "#313244"
            }

            Column {
                id: topTabs
                x: 12
                y: 62
                z: 1
                width: sidebar.width - 24
                spacing: settings.tabSpacing

                SidebarTab { tab: "main"; labelKey: "main" }
            }

            Column {
                id: bottomTabs
                x: 12
                y: sidebar.height - height - 12
                z: 1
                width: sidebar.width - 24
                spacing: settings.tabSpacing

                SidebarTab { tab: "console"; labelKey: "console" }
                SidebarTab { tab: "setter"; labelKey: "setter" }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                anchors.fill: parent
                opacity: settings.currentTab === "main" ? 1 : 0
                visible: opacity > 0
                enabled: settings.currentTab === "main"
                z: enabled ? 1 : 0
                Behavior on opacity {
                    enabled: preferences.animations && preferences.content
                    NumberAnimation { duration: 180 }
                }

                Text {
                    anchors.centerIn: parent
                    text: settings.labelFor("mainHint")
                    color: "#6c7086"
                }
            }

            Item {
                anchors.fill: parent
                opacity: settings.currentTab === "console" ? 1 : 0
                visible: opacity > 0
                enabled: settings.currentTab === "console"
                z: enabled ? 1 : 0
                Behavior on opacity {
                    enabled: preferences.animations && preferences.content
                    NumberAnimation { duration: 180 }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 10

                    Text {
                        text: settings.labelFor("logsTitle")
                        color: "#cdd6f4"
                        font.bold: true
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        TextArea {
                            readOnly: true
                            selectByMouse: true
                            text: logger.history || settings.labelFor("logsWaiting")
                            color: "#cdd6f4"
                            font.family: "monospace"
                            font.pixelSize: 11
                            wrapMode: TextEdit.WrapAnywhere
                            background: Rectangle {
                                color: "#11111b"
                                radius: settings.innerRadius
                            }
                            onTextChanged: cursorPosition = length
                        }
                    }
                }
            }

            Item {
                anchors.fill: parent
                opacity: settings.currentTab === "setter" ? 1 : 0
                visible: opacity > 0
                enabled: settings.currentTab === "setter"
                z: enabled ? 1 : 0
                Behavior on opacity {
                    enabled: preferences.animations && preferences.content
                    NumberAnimation { duration: 180 }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 22
                    spacing: 12

                    Text {
                        text: settings.labelFor("appearanceTitle")
                        color: "#cdd6f4"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    Text {
                        text: settings.labelFor("animationsTitle")
                        color: "#a6adc8"
                        Layout.topMargin: 12
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: switches.implicitHeight + 16
                        radius: settings.innerRadius
                        color: "#181825"

                        ColumnLayout {
                            id: switches
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 4

                            SettingsSwitch {
                                labelKey: "animationsAll"
                                checked: preferences.animations
                                onToggled: preferences.animations = !preferences.animations
                            }
                            SettingsSwitch {
                                labelKey: "animationsTabs"
                                checked: preferences.tabs
                                onToggled: preferences.tabs = !preferences.tabs
                            }
                            SettingsSwitch {
                                labelKey: "animationsSwitches"
                                checked: preferences.switches
                                onToggled: preferences.switches = !preferences.switches
                            }
                            SettingsSwitch {
                                labelKey: "animationsContent"
                                checked: preferences.content
                                onToggled: preferences.content = !preferences.content
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }
    }

    component SidebarTab: Item {
        required property string tab
        required property string labelKey

        width: parent.width
        height: settings.tabHeight

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
            text: settings.labelFor(labelKey)
            color: settings.currentTab === tab ? "#cba6f7" : "#a6adc8"
            font.bold: settings.currentTab === tab
            Behavior on color {
                enabled: preferences.animations && preferences.tabs
                ColorAnimation { duration: 180 }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: settings.selectTab(tab)
        }
    }

    component SettingsSwitch: Item {
        required property string labelKey
        required property bool checked
        signal toggled()

        Layout.fillWidth: true
        Layout.preferredHeight: 44

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            text: settings.labelFor(labelKey)
            color: "#cdd6f4"
        }

        Rectangle {
            id: track
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            width: 40
            height: 22
            radius: height / 2
            color: checked ? "#cba6f7" : "#45475a"
            Behavior on color {
                enabled: preferences.animations && preferences.switches
                ColorAnimation { duration: 160 }
            }

            Rectangle {
                width: 16
                height: 16
                y: 3
                x: checked ? track.width - width - 3 : 3
                radius: height / 2
                color: "#11111b"

                Behavior on x {
                    enabled: preferences.animations && preferences.switches
                    NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: toggled()
        }
    }
}
