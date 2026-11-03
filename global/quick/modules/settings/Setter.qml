import QtQuick

Item {
    id: root

    required property string desktopName

    Loader {
        anchors.fill: parent
        source: root.desktopName === "driftwm"
            ? Qt.resolvedUrl("../../../../driftwm/quick/modules/settings/DriftwmSettings.qml")
            : ""
    }

    Text {
        anchors.centerIn: parent
        visible: root.desktopName !== "driftwm"
        text: "нет интерфейса настроек для " + (root.desktopName || "этого десктопа")
        color: "white"
    }
}
