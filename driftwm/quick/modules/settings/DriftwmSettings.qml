import QtQuick

Item {
    id: root

    readonly property var tabs: ["главная", "оформление"]
    property string currentTab: "главная"

    Text {
        anchors.centerIn: parent
        text: root.currentTab + " — настройки появятся здесь"
        color: "white"
    }
}
