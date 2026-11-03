import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel

ColumnLayout {
    id: picker

    required property string desktop
    required property string label
    required property string configLabel
    property real cornerRadius: 12
    property string configPath: ""
    signal desktopSelected(string desktop)

    spacing: 8

    FolderListModel {
        id: desktops
        folder: Qt.resolvedUrl("../desktops")
        nameFilters: ["*.json"]
        showDirs: false
        sortField: FolderListModel.Name
    }

    FileView {
        id: description
        path: /^[a-z0-9_-]+$/.test(picker.desktop)
            ? Qt.resolvedUrl("../desktops/" + picker.desktop + ".json") : ""
        blockLoading: true
        printErrors: false
        watchChanges: true
        onPathChanged: picker.configPath = ""
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text())
                picker.configPath = typeof data.config === "string" ? data.config : ""
            } catch (error) {
                console.warn("[meowdots] setter | invalid desktop description: " + error)
                picker.configPath = ""
            }
        }
        onLoadFailed: picker.configPath = ""
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 10

        Text {
            text: picker.label
            color: "#cdd6f4"
            font.bold: true
        }

        ComboBox {
            id: combo
            Layout.preferredWidth: 180
            model: desktops
            textRole: "fileBaseName"
            valueRole: "fileBaseName"
            currentIndex: {
                for (let index = 0; index < count; index++) {
                    if (valueAt(index) === picker.desktop) return index
                }
                return -1
            }
            onActivated: picker.desktopSelected(currentValue)

            contentItem: Text {
                leftPadding: 12
                verticalAlignment: Text.AlignVCenter
                text: combo.displayText
                color: "#cdd6f4"
            }
            background: Rectangle {
                color: "#313244"
                radius: picker.cornerRadius
            }
        }
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        visible: picker.configPath !== ""
        text: picker.configLabel + " " + picker.configPath
        color: "#6c7086"
        font.pixelSize: 12
    }
}
