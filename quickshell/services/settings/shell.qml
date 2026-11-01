import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../logger" as Logs

FloatingWindow {
    id: settings

    signal closeRequested()

    title: "meowdots settings"
    implicitWidth: 780
    implicitHeight: 480
    color: "#1e1e2e"

    property string currentTab: "main"
    property bool wasVisible: false

    onVisibleChanged: {
        if (visible) wasVisible = true
        else if (wasVisible) closeRequested()
    }

    // Created and destroyed with the settings window.
    Logs.LogReader { id: logger }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 180
            Layout.fillHeight: true
            color: "#181825"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "meowdots"
                    color: "#cdd6f4"
                    font.bold: true
                    font.pixelSize: 16
                    Layout.bottomMargin: 12
                }

                SidebarTab { label: "главная"; tab: "main" }
                Item { Layout.fillHeight: true }
                SidebarTab { label: "консоль"; tab: "console" }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Item {
                anchors.fill: parent
                visible: settings.currentTab === "main"
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 10
                visible: settings.currentTab === "console"

                Text {
                    text: "логи Quickshell"
                    color: "#cdd6f4"
                    font.bold: true
                }

                ScrollView {
                    id: logScroll
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    TextArea {
                        readOnly: true
                        selectByMouse: true
                        text: logger.history || "ожидание логов…"
                        color: "#cdd6f4"
                        font.family: "monospace"
                        font.pixelSize: 11
                        wrapMode: TextEdit.WrapAnywhere
                        background: Rectangle { color: "#11111b"; radius: 8 }

                        onTextChanged: cursorPosition = length
                    }
                }
            }
        }
    }

    component SidebarTab: Rectangle {
        required property string label
        required property string tab

        Layout.fillWidth: true
        Layout.preferredHeight: 36
        radius: 8
        color: settings.currentTab === tab ? "#313244" : "transparent"

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 12
            text: label
            color: settings.currentTab === tab ? "#cba6f7" : "#a6adc8"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: settings.currentTab = tab
        }
    }
}
