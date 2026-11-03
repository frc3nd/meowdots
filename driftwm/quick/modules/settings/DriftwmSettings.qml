import QtQuick
import QtQuick.Layouts
import "." as Parts

Item {
    id: root

    property string currentTab: "главная"

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Parts.Sidebar {
            Layout.preferredWidth: 190
            Layout.fillHeight: true
            currentTab: root.currentTab
            onTabSelected: tab => root.currentTab = tab
        }

        Parts.TileCanvas {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentTab: root.currentTab
        }
    }
}
