import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: picker

    required property var languages
    required property string language
    required property string label
    property real cornerRadius: 12
    signal selected(string code)

    spacing: 8

    Text {
        text: picker.label
        color: "#a6adc8"
    }

    ComboBox {
        id: combo
        Layout.preferredWidth: 180
        model: picker.languages
        textRole: "fileBaseName"
        valueRole: "fileBaseName"
        currentIndex: {
            for (let index = 0; index < count; index++) {
                if (valueAt(index) === picker.language) return index
            }
            return -1
        }
        onActivated: picker.selected(currentValue)

        contentItem: Text {
            leftPadding: 12
            verticalAlignment: Text.AlignVCenter
            text: combo.displayText
            color: "#cdd6f4"
        }
        background: Rectangle {
            color: "#313244"
            radius: picker.cornerRadius
        }
    }
}
