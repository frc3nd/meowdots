import QtQuick

Item {
    id: root

    property string tabId: ""
    property string icon: ""
    property string label: ""
    property bool selected: false
    property bool animationsEnabled: true
    property real uiScale: 1

    signal clicked(string tabId)

    implicitHeight: 40 * uiScale
    clip: true

    Rectangle {
        anchors.fill: parent
        radius: 10 * root.uiScale
        color: root.selected ? "#484860" : "transparent"
    }

    Rectangle {
        width: 36 * root.uiScale
        height: width
        radius: 9 * root.uiScale
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: root.selected ? "#60607a" : "#383848"

        Text {
            anchors.centerIn: parent
            text: root.icon
            color: "white"
            font.pixelSize: 19 * root.uiScale
        }
    }

    Repeater {
        model: root.label.length

        Text {
            id: letter
            required property int index

            text: root.label.charAt(index)
            x: 50 * root.uiScale + prefix.advanceWidth
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 14 * root.uiScale
            opacity: root.animationsEnabled
                ? Math.max(0, Math.min(1,
                    (root.width - 4 * root.uiScale - x - implicitWidth) / (5 * root.uiScale)))
                : (root.width - 4 * root.uiScale >= x + implicitWidth ? 1 : 0)

            TextMetrics {
                id: prefix
                font: letter.font
                text: root.label.slice(0, letter.index)
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked(root.tabId)
    }
}
