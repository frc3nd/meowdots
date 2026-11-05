import QtQuick

Item {
    id: root

    property bool collapsed: false
    property real uiScale: 1
    property real collapseProgress: 0

    signal toggled()

    width: (30 + 34 * collapseProgress) * uiScale
    height: 46 * uiScale

    Canvas {
        id: drop
        anchors.fill: parent
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.fillStyle = "#484860"
            ctx.beginPath()
            ctx.moveTo(width, 0)
            ctx.lineTo(width, height)
            ctx.bezierCurveTo(width * 0.4, height * 0.84, 0, height * 0.85, 0, height / 2)
            ctx.bezierCurveTo(0, height * 0.15, width * 0.4, height * 0.16, width, 0)
            ctx.closePath()
            ctx.fill()
        }
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 10 * root.uiScale
        anchors.verticalCenter: parent.verticalCenter
        text: root.collapsed ? "›" : "‹"
        color: "white"
        font.bold: true
        font.pixelSize: 22 * root.uiScale
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggled()
    }
}
