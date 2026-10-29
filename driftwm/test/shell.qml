import QtQuick
import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel

PanelWindow {
    id: root
    
    // окно по центру экрана
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }
    
    color: "#aa000000" // полупрозрачный фон

    Rectangle {
        anchors.centerIn: parent
        width: 600
        height: 400
        color: "#1e1e2e"
        radius: 16

        Text {
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            text: "meowdots theme switcher"
            color: "#cdd6f4"
            font.pixelSize: 20
            font.bold: true
        }

        // список тем будет выводиться здесь
        ListView {
            id: themeList
            anchors.fill: parent
            anchors.margins: 60
            spacing: 10
            orientation: ListView.Horizontal

            model: FolderListModel {
                // тут подключаем парсинг папки themes
            }
        }
    }
}
