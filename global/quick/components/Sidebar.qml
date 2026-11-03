import QtQuick

Rectangle {
    id: root

    property var tabs: []
    property string currentTab: ""
    property var labelFor: key => key
    signal tabSelected(string tab)

    color: "#282838"

    Column {
        anchors.fill: parent
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
                    text: root.labelFor(modelData)
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.tabSelected(parent.modelData)
                }
            }
        }
    }
}
