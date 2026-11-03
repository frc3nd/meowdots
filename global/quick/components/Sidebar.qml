import QtQuick

Rectangle {
    id: root

    property var tabs: []
    property string currentTab: ""
    property var labelFor: key => key
    property bool collapsed: false
    property bool animationsEnabled: true
    property real animationSpeed: 1
    signal tabSelected(string tab)

    implicitWidth: collapsed ? 56 : 190
    clip: true
    color: "#282838"

    Behavior on implicitWidth {
        enabled: root.animationsEnabled
        NumberAnimation {
            duration: 240 / Math.max(root.animationSpeed, 0.1)
            easing.type: Easing.InOutCubic
        }
    }

    Column {
        anchors.top: parent.top
        anchors.bottom: collapseButton.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 12
        spacing: 8

        Repeater {
            model: root.tabs

            Rectangle {
                required property string modelData

                width: parent.width
                height: 40
                radius: 8
                color: root.currentTab === modelData ? "#484860" : "transparent"

                Text {
                    anchors.centerIn: parent
                    text: root.collapsed
                        ? root.labelFor(modelData).charAt(0).toUpperCase()
                        : root.labelFor(modelData)
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.tabSelected(parent.modelData)
                }
            }
        }
    }

    Rectangle {
        id: collapseButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        height: 40
        radius: 8
        color: "#484860"

        Text {
            anchors.centerIn: parent
            text: root.collapsed ? "»" : "«"
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.collapsed = !root.collapsed
        }
    }
}
