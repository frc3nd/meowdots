// testing

import Quickshell
import QtQuick
import QtQuick.Controls

FloatingWindow {
    id: settings

    title: "meowdots settings"
	implicitWidth: 700
	implicitHeight: 450
    color: "transparent"

    property bool isPreview: false

    onVisibleChanged: {
        if (!visible) Qt.quit()
    }

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#1e1e2e"
        opacity: settings.isPreview ? 0.0 : 1.0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

	Rectangle {
	    id: toggle
	    anchors.centerIn: parent
	    width: 52
	    height: 30
	    radius: height / 2
	    
	    color: settings.isPreview ? "#cba6f7" : "#313244"
	    border.width: settings.isPreview ? 0 : 2
	    border.color: "#45475a"

	    Behavior on color { ColorAnimation { duration: 200 } }

	    Rectangle {
	        id: thumb
	        width: 20
	        height: 20
	        radius: height / 2
	        anchors.verticalCenter: parent.verticalCenter
	        
	        x: settings.isPreview ? (toggle.width - width - 5) : 5
	        color: settings.isPreview ? "#11111b" : "#a6adc8"

	        Behavior on x { 
	            NumberAnimation { duration: 200; easing.type: Easing.OutCubic } 
	        }
	    }

	    MouseArea {
	        anchors.fill: parent
	        cursorShape: Qt.PointingHandCursor
	        onClicked: settings.isPreview = !settings.isPreview
	    }
	}
}
