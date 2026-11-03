import QtQuick

Item {
    id: root

    property string currentTab: "главная"

    clip: true

    Text {
        anchors.centerIn: parent
        text: root.currentTab + " — настройки появятся здесь"
        color: "white"
    }
}
