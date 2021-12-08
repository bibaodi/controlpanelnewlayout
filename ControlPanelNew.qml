import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
    width: 640+40+50
    height: 420
    visible: true

    Column {
        id: id_column_all
        x: 15
        y: 7
        width: parent.width - 20
        height: parent.height - 10

        Row {
            // input
            id: id_row_display
            width: parent.width
            height: 20
            Text {
                id: display_label
                height: parent.height + 5
                width: height*1.5
                text: "Display:"
                font.pixelSize: 9
            }

            TextInput {
                id: id_textInput
                cursorVisible: true
                color: "blue"
                font.pixelSize: 9
                width: parent.width - display_label.width - id_clearButton.width
                clip: true
                echoMode: TextInput.Normal
            }

            ControlPanelButton {                // clear x
                id: id_clearButton
                text: '\u2715' // BLACK DOWN-POINTING TRIANGLE
                height: parent.height
                width: height
                enabled: id_textInput.text
                onClicked: {
                    console.log("clear clicked")
                    id_textInput.clear();
                }
            }
        }

        Row {
            id: id_row_power
            width: parent.width
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton.width * 2)

            ControlPanelButton {
                id: roundButton
                text: "POWER"
                font.pixelSize: 8
            }

            ControlPanelButton {
                id: roundButton1
                text: "VOL"
            }
        }

        Row {
            id: id_row_6knobs
            width: parent.width * 0.7
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton2.width * 6) / 5

            ControlPanelButton {
                id: roundButton2
                text: "R1"
            }

            ControlPanelButton {
                id: roundButton3
                text: "R2"
            }

            ControlPanelButton {
                id: roundButton4
                text: "R3"
            }

            ControlPanelButton {
                id: roundButton5
                text: "R4"
            }

            ControlPanelButton {
                id: roundButton6
                text: "R5"
            }

            ControlPanelButton {
                id: roundButton7
                text: "R6"
            }
        }

        Row {
            id: id_row_5modes
            width: parent.width * 0.6
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton2.width * 5) / 4

            ControlPanelButton {
                id: roundButton8
                text: "M"
                anchors.bottom: parent.bottom
            }

            ControlPanelButton {
                id: roundButton9
                text: "E"
                y: 5
            }

            ControlPanelButton {
                id: roundButton10
                anchors.top: parent.top
                text: "D"
                function_text: "pw/cw"
            }

            ControlPanelButton {
                id: roundButton11
                text: "C"
                y:5
            }

            ControlPanelButton {
                id: roundButton12
                text: "B"
                anchors.bottom: parent.bottom
            }
        }

        Row {
            id: id_row_spacing
            height: 15
            Rectangle {
                height: parent.height
                width: 100
                color: "transparent"
            }
        }

        Row {
            id: id_row_halfBottom
            width: parent.width
            height: parent.height - id_row_power.height - id_row_6knobs.height - id_row_5modes.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 1

            Column {
                id: id_col_patient
                width: 60
                height: roundButton2.height * 3
                anchors.verticalCenter: parent.verticalCenter
                spacing: (height - roundButton13.height * 2)
                ControlPanelButton {
                    id: roundButton13
                    text: "patient"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                ControlPanelButton {
                    id: roundButton14
                    text: "EndExm"
                    anchors.left: parent.left
                    font.pixelSize: 9
                }
            }

            Column {
                id: column2
                width: 60
                height: roundButton2.height * 3
                anchors.verticalCenter: parent.verticalCenter
                spacing: (height - roundButton15.height * 2)
                ControlPanelButton {
                    id: roundButton15
                    text: "probe"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                ControlPanelButton {
                    id: roundButton16
                    text: "arrow"
                    anchors.left: parent.left
                    font.pixelSize: 9
                }
            }

            Column {
                id: column6
                width: 50
                height: parent.height
            }

            Column {
                id: id_col_center_rect
                width: id_row_5modes.width - roundButton11.width*1.5
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: id_row_slider
                    width: parent.width
                    height: 30
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color:"#0000ff"
                        border.color: "#ee7b0e"
                        Text {
                            id: slider_text
                            text: qsTr("<------------------------------------>")
                            color: "#ffffff"
                            font.bold: true
                            antialiasing: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
                Row {
                    id:id_row_space_after_slider
                    height:3
                    width: parent.width
                }
                Row {
                    id: id_row_trackball
                    width: parent.width
                    height: parent.height - id_row_slider.height
                    spacing: (width-column_annotation.width-column_ball.width-column_clip_img.width)/2

                    Column {
                        id: column_annotation
                        width: parent.width*0.15
                        height: parent.height
                        spacing: 5
                        ControlPanelButton {
                            id: button_Annot
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("ABC")
                            function_text: "Annot"
                            font.pixelSize: 9
                            radius: 0
                        }

                        ControlPanelButton {
                            id: button_meas
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Meas")
                            function_text: "caliper"
                            font.pixelSize: 9
                            radius: 0
                        }
                    }

                    Column {
                        id: column_ball
                        width: parent.width - column_annotation.width - column_clip_img.width
                        height: parent.height
                        spacing: 3
                        Row {
                            id: row_mouse
                            width: parent.width
                            height: parent.height

                            ControlPanelButton {
                                id: button_mouse_left
                                text: qsTr("Left")
                                anchors.top: parent.top
                                width: column_ball.width/2
                                height: parent.height-5
                                background: Rectangle {
                                    color: 'transparent'
                                    anchors.fill: parent
                                }
                                Image {
                                    width: parent.width
                                    height: parent.height
                                    source: parent.down? "":"pics/controlPanel-left.png"
                                }
                            }

                            ControlPanelButton {
                                id: button_mouse_right
                                text: qsTr("Right")
                                anchors.top: parent.top
                                width: column_ball.width/2-3
                                height: parent.height-5
                                background: Rectangle {
                                    color: 'transparent'
                                    anchors.fill: parent
                                }
                                Image {
                                    width: parent.width
                                    height: parent.height
                                    source: parent.down? "":"pics/controlPanel-right.png"
                                }
                            }
                        }

                    }

                    Column {
                        id: column_clip_img
                        width: parent.width*0.15
                        height: parent.height
                        spacing: 5
                        ControlPanelButton {
                            id: button_clip
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Clip")
                            font.pixelSize: 9
                            radius: 0
                        }

                        ControlPanelButton {
                            id: button_img
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Img")
                            font.pixelSize: 9
                            radius: 0
                        }
                    }
                }
            }

            Column {
                id: column7
                width: 20
                height: parent.height
            }

            Column {
                id: column4
                width: 70
                height: roundButton2.height * 5
                y: roundButton.height*2
                spacing: (height - roundButton15.height * 3)/5

                ControlPanelButton {
                    id: roundButton17
                    text: "P1"

                }

                ControlPanelButton {
                    id: roundButton18
                    text: "iTuner"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                ControlPanelButton {
                    id: roundButton22
                    text: "Freeze"
                    anchors.left: parent.left
                    font.pixelSize: 9
                    width: roundButton18.width*1.5
                    height: width
                    background: Rectangle {
                        color: roundButton22.down? "":"#ff8c00"
                        radius: 100
                    }
                }
            }


            Column {
                id: column5
                width: 60
                height: roundButton19.width*4
                spacing: (height - roundButton19.height * 3)/2

                ControlPanelButton {
                    id: roundButton19
                    text: "zoom"
                    x:-30
                    font.pixelSize: 9
                }

                ControlPanelButton {
                    id: roundButton20
                    text: "focus"
                    font.pixelSize: 9
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                ControlPanelButton {
                    id: roundButton21
                    text: "depth"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }
            }


        }
    }

    //attention: because this button cannot be put in column or row,
    // so only position it with absulute coordinate.
    ControlPanelButton {
        id: button_update
        radius: 0
        x: id_row_halfBottom.x + id_row_halfBottom.width/2.5 +14
        y: id_row_halfBottom.y + 40
        width: 145
        height: 45
        text: qsTr("Update")
        background: Rectangle {
            color: 'transparent'
            anchors.fill: parent
        }
        Image {
            id: image
            width: parent.width
            height: parent.height
            source: parent.down? "":"pics/controlPanel-update.png"
        }
    }
}
