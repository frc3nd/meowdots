import QtQuick
import QtQuick.Layouts
import "../../components" as Ui
import "../../services" as Services

Item {
    id: root

    required property string desktopName
    property string language: "ru"
    property string currentTab: ""

    Services.Localization {
        id: localization
        localesDir: Qt.resolvedUrl("locales")
        language: root.language
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Ui.Sidebar {
            Layout.preferredWidth: 190
            Layout.fillHeight: true
            tabs: desktopPage.item ? desktopPage.item.tabs : []
            currentTab: root.currentTab
            labelFor: key => localization.text(key)
            onTabSelected: tab => root.currentTab = tab
        }

        Ui.TileCanvas {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Loader {
                id: desktopPage
                anchors.fill: parent
                source: root.desktopName === "driftwm"
                    ? Qt.resolvedUrl("../../../../driftwm/quick/modules/settings/DriftwmSettings.qml")
                    : ""
                onLoaded: root.currentTab = item.tabs[0] || ""
            }

            Binding {
                target: desktopPage.item
                property: "currentTab"
                value: root.currentTab
                when: desktopPage.item !== null
            }

            Text {
                anchors.centerIn: parent
                visible: !desktopPage.item && root.desktopName !== "driftwm"
                text: localization.text("unsupportedDesktop")
                    .replace("%1", root.desktopName || "?")
                color: "white"
            }
        }
    }
}
