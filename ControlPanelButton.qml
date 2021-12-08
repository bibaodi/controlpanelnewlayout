//import Qt.virtualpanelexposing.qobjectSingleton 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.12 as T

T.RoundButton {
    id: id_controlpanel_btn
    property bool testing_left_show: false
    property bool testing_right_show: false
    property string function_text: ""
    objectName: function_text?function_text:text
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 6

    icon.width: 24
    icon.height: 24
    icon.color: id_controlpanel_btn.checked || id_controlpanel_btn.highlighted ? id_controlpanel_btn.palette.brightText :
                id_controlpanel_btn.flat && !id_controlpanel_btn.down ? (id_controlpanel_btn.visualFocus ? id_controlpanel_btn.palette.highlight : id_controlpanel_btn.palette.windowText) : id_controlpanel_btn.palette.buttonText

    contentItem: IconLabel {
        spacing: id_controlpanel_btn.spacing
        mirrored: id_controlpanel_btn.mirrored
        display: id_controlpanel_btn.display

        icon: id_controlpanel_btn.icon
        text: id_controlpanel_btn.text
        font: id_controlpanel_btn.font
        color: id_controlpanel_btn.checked || id_controlpanel_btn.highlighted ? id_controlpanel_btn.palette.brightText :
               id_controlpanel_btn.flat && !id_controlpanel_btn.down ? (id_controlpanel_btn.visualFocus ? id_controlpanel_btn.palette.highlight : id_controlpanel_btn.palette.windowText) : id_controlpanel_btn.palette.buttonText
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 40
        radius: id_controlpanel_btn.radius
        opacity: enabled ? 1 : 0.3
        visible: !id_controlpanel_btn.flat || id_controlpanel_btn.down || id_controlpanel_btn.checked || id_controlpanel_btn.highlighted
        color: Color.blend(id_controlpanel_btn.checked || id_controlpanel_btn.highlighted ? id_controlpanel_btn.palette.dark : id_controlpanel_btn.palette.button,
                                                                    id_controlpanel_btn.palette.mid, id_controlpanel_btn.down ? 0.5 : 0.0)
        border.color: id_controlpanel_btn.palette.highlight
        border.width: id_controlpanel_btn.visualFocus ? 2 : 0
            Rectangle {
                id: id_left
                width: parent.width /3
                height: parent.height/3
                color: "#00ff00"
                visible: id_controlpanel_btn.testing_left_show
            }
            Rectangle {
                id: id_right
                anchors.right: parent.right
                width: parent.width /3
                height: parent.height/3
                color: "#00f0b0"
                visible: id_controlpanel_btn.testing_right_show
            }

    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        preventStealing: true
        onPressed: {
            //BUG: for when press "B" the "Left" will be responsed. do not found the reason.
            console.log("debug: pressed:", id_controlpanel_btn.text, "coordinate:local(", mouse.x, ",", mouse.y, ")");
            var pos = mapToGlobal(mouse.x , mouse.y)
            console.log("debug: pressed:", id_controlpanel_btn.text, "coordinate:global(", pos.x, ",", pos.y, ")");
            mouse.accepted = false
        }
        onClicked: {
            mouse.accepted = false
        }
        onReleased: {
            mouse.accepted = false
        }

        onWheel: {
            function inArray(needle, haystack) {
                if ("string" != typeof needle) {
                    return false
                }
                var count = haystack.length
                for (var i = 0; i < count; i++) {
                    if (haystack[i].toLowerCase() === needle.toLowerCase()) {
                        return true
                    }
                }
                return false
            }
            var position;
            var key_text = id_controlpanel_btn.function_text.length>0?id_controlpanel_btn.function_text: id_controlpanel_btn.text;
            var wheel_angelDelta_y = wheel.angleDelta.y;

            var disable_scroll = ["patient", "EndExm", "probe", "arrow",
                                  "abc", "meas", "clip", "img",
                                  "freeze", "p1", "ituner", "update",
                                  "left", "right", "power"]
            if (inArray(key_text, disable_scroll)) {
                console.log("button only,not support scroll:",  key_text)
                return
            }

            var key_action = "press"
            if (wheel_angelDelta_y > 0) {
                key_action = "right"
            } else if (wheel_angelDelta_y < 0) {
                key_action = "left"
            } else {
                console.log("angleDelta=0", wheel_angelDelta_y)
            }
            if (wheel_angelDelta_y) {
                position = id_textInput.cursorPosition
                id_textInput.text = id_textInput.text.substring(
                            0,
                            id_textInput.cursorPosition) + key_text + "(" + key_action
                        + ")" + id_textInput.text.substring(id_textInput.cursorPosition,
                                                         id_textInput.text.length)
                id_textInput.cursorPosition = position + key_text.length + key_action.length + 2
                //VcpApi.cppSlot(key_text, key_action)
            }
        }
    }

    onClicked: {
        var key_text = id_controlpanel_btn.function_text.length>0?id_controlpanel_btn.function_text: id_controlpanel_btn.text;

        if (!key_text) {
            return
        }
        var position;
        if (key_text === '\u2190') { // LEFTWARDS ARROW (backspace)
            position = id_textInput.cursorPosition
            id_textInput.text = id_textInput.text.substring(
                        0,
                        id_textInput.cursorPosition - 1) + id_textInput.text.substring(
                        id_textInput.cursorPosition, id_textInput.text.length)
            id_textInput.cursorPosition = position - 1
        } else if (key_text === '\u21B5') {
            accepted(id_textInput.text)
        } else {
            position = id_textInput.cursorPosition
            id_textInput.text = id_textInput.text.substring(
                        0,
                        id_textInput.cursorPosition) + key_text + "(press)" + id_textInput.text.substring(
                        id_textInput.cursorPosition, id_textInput.text.length)
            id_textInput.cursorPosition = position + key_text.length + 7
        }
        //VcpApi.cppSlot(key_text, "press")
    }
}
