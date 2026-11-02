import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../services/logger" as Logs
import "../../services/state" as State
import "../../services/theme" as Themes
import "." as Setter
import "components" as Ui

FloatingWindow {
    id: settings

    signal closeRequested()
    signal languageSelected(string language)

    title: "meowdots — " + labelFor("windowTitle")
    implicitWidth: 820
    implicitHeight: 510
    color: "#1e1e2e"

    property string language: "ru"
    property string themeName: "default"
    property string currentTab: "main"
    property bool wasVisible: false

    // DriftWM rounds the outer window itself. Keep this separate for other WMs.
    property real windowRadius: theme.cornerRadius
    property real elementRadius: theme.cornerRadius
    property bool separateRadii: true
    readonly property real innerRadius: separateRadii ? elementRadius : windowRadius

    function labelFor(key: string): string {
        return localization.text(key)
    }

    onVisibleChanged: {
        if (visible) wasVisible = true
        else if (wasVisible) closeRequested()
    }

    onClosed: closeRequested()

    State.SetterPreferences { id: preferences }
    Themes.Theme { id: theme; themeName: settings.themeName }
    Setter.Localization { id: localization; language: settings.language }
    Logs.LogReader { id: logger }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Ui.Sidebar {
            id: sidebar
            currentTab: settings.currentTab
            expanded: preferences.sidebarExpanded
            animateTabs: preferences.animations && preferences.tabs
            animateSidebar: preferences.animations && preferences.sidebar
            animationReady: preferences.ready
            cornerRadius: settings.innerRadius
            labelFor: settings.labelFor
            onTabSelected: tab => settings.currentTab = tab
            onExpansionToggled: preferences.sidebarExpanded = !preferences.sidebarExpanded
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

                    Ui.LanguagePicker {
                        Layout.topMargin: 12
                        languages: localization.languages
                        language: settings.language
                        label: settings.labelFor("languageTitle")
                        cornerRadius: settings.innerRadius
                        onSelected: code => settings.languageSelected(code)
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

                            Ui.SettingSwitch {
                                label: settings.labelFor("animationsAll")
                                checked: preferences.animations
                                animate: preferences.animations && preferences.switches
                                onToggled: preferences.animations = !preferences.animations
                            }
                            Ui.SettingSwitch {
                                label: settings.labelFor("animationsTabs")
                                checked: preferences.tabs
                                animate: preferences.animations && preferences.switches
                                onToggled: preferences.tabs = !preferences.tabs
                            }
                            Ui.SettingSwitch {
                                label: settings.labelFor("animationsSidebar")
                                checked: preferences.sidebar
                                animate: preferences.animations && preferences.switches
                                onToggled: preferences.sidebar = !preferences.sidebar
                            }
                            Ui.SettingSwitch {
                                label: settings.labelFor("animationsSwitches")
                                checked: preferences.switches
                                animate: preferences.animations && preferences.switches
                                onToggled: preferences.switches = !preferences.switches
                            }
                            Ui.SettingSwitch {
                                label: settings.labelFor("animationsContent")
                                checked: preferences.content
                                animate: preferences.animations && preferences.switches
                                onToggled: preferences.content = !preferences.content
                            }
                        }
                    }

                    Item { Layout.fillHeight: true }
                }
            }
        }
    }

}
