import QtQuick

Text {
    required property string name

    text: name === "main" ? "⌂"
        : name === "console" ? ">_"
        : name === "setter" ? "⚙"
        : name === "collapse" ? "‹" : "›"
    font.pixelSize: name === "collapse" || name === "expand" ? 22 : 18
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
}
