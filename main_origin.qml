import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: id_window
    objectName: "root_cp_window"
    width: 640+40
    height: 480
    visible: true
    property alias image: image
    title: qsTr("TestingControlPanel")

    Column {
        id: column
        x: 23
        y: 17
        width: 620
        height: 400

        Row {
            id: row0
            width: parent.width
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton.width * 2)

            RoundButton {
                id: roundButton
                text: "POWER"
                font.pixelSize: 8
            }

            RoundButton {
                id: roundButton1
                text: "VOL"
            }
        }

        Row {
            id: row1
            width: parent.width * 0.7
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton2.width * 6) / 5

            RoundButton {
                id: roundButton2
                text: "R1"
            }

            RoundButton {
                id: roundButton3
                text: "R2"
            }

            RoundButton {
                id: roundButton4
                text: "R3"
            }

            RoundButton {
                id: roundButton5
                text: "R4"
            }

            RoundButton {
                id: roundButton6
                text: "R5"
            }

            RoundButton {
                id: roundButton7
                text: "R6"
            }
        }

        Row {
            id: row2
            width: parent.width * 0.6
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton2.width * 5) / 4

            RoundButton {
                id: roundButton8
                text: "M"
                anchors.bottom: parent.bottom
            }

            RoundButton {
                id: roundButton9
                text: "E"
                y: 5
            }

            RoundButton {
                id: roundButton10
                anchors.top: parent.top
                text: "D"
            }

            RoundButton {
                id: roundButton11
                text: "C"
                y:5
            }

            RoundButton {
                id: roundButton12
                text: "B"
                anchors.bottom: parent.bottom
            }
        }

        Row {
            id: row3
            width: parent.width
            height: parent.height - row0.height - row1.height - row2.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 1

            Column {
                id: column1
                width: 60
                height: roundButton2.height * 3
                anchors.verticalCenter: parent.verticalCenter
                spacing: (height - roundButton13.height * 2)
                RoundButton {
                    id: roundButton13
                    text: "patient"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                RoundButton {
                    id: roundButton14
                    text: "End"
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
                RoundButton {
                    id: roundButton15
                    text: "probe"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                RoundButton {
                    id: roundButton16
                    text: "arrow"
                    anchors.left: parent.left
                    font.pixelSize: 9
                }
            }

            Column {
                id: column6
                width: 30
                height: parent.height
            }

            Column {
                id: column3
                width: row2.width - roundButton11.width*1.5
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: row_slider
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
                Row{
                    id:row_space_after_slider
                    height:3
                    width: parent.width
                }
                Row {
                    id: row_mouse_ball
                    width: parent.width
                    height: parent.height - row_slider.height
                    spacing: (width-column_annotation.width-column_ball.width-column_clip_img.width)/2

                    Column {
                        id: column_annotation
                        width: parent.width*0.15
                        height: parent.height
                        spacing: 5
                        Button {
                            id: button_Annot
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("ABC")
                            font.pixelSize: 9

                        }

                        Button {
                            id: button_meas
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Meas")
                            font.pixelSize: 9
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

                            Button {
                                id: button_mouse_left
                                text: qsTr("Left")
                                background: transientParent
                                anchors.top: parent.top
                                width: column_ball.width/2
                                height: parent.height-5
                                Image {
                                    width: parent.width
                                    height: parent.height
                                    source: parent.down? "":"pics/controlPanel-left-211125.png"
                                }
                            }

                            Button {
                                id: button_mouse_right
                                text: qsTr("Right")
                                background: transientParent
                                anchors.top: parent.top
                                width: column_ball.width/2-3
                                height: parent.height-5

                                Image {
                                    width: parent.width
                                    height: parent.height
                                    source: parent.down? "":"pics/controlPanel-right-211125.png"
                                }
                            }
                        }

                    }

                    Column {
                        id: column_clip_img
                        width: parent.width*0.15
                        height: parent.height
                        spacing: 5
                        Button {
                            id: button_clip
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Clip")
                            font.pixelSize: 9

                        }

                        Button {
                            id: button_img
                            height: (parent.height-10)/2
                            width: parent.width
                            text: qsTr("Image")
                            font.pixelSize: 9
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

                RoundButton {
                    id: roundButton17
                    text: "P1"

                }

                RoundButton {
                    id: roundButton18
                    text: "iTuner"
                    anchors.right: parent.right
                    font.pixelSize: 9
                }

                RoundButton {
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

                RoundButton {
                    id: roundButton19
                    text: "zoom"
                    x:-30
                    font.pixelSize: 9
                    objectName: text
                }

                RoundButton {
                    id: roundButton20
                    text: "focus"
                    font.pixelSize: 9
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                RoundButton {
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
    Button {
        id: button_update
        x: row3.x + row3.width/2.28
        y: 230
        width: 120
        height: 45
        text: qsTr("Update")
        highlighted: true
        background: transientParent
        Image {
            id: image
            width: parent.width
            height: parent.height
            source: parent.down? "":"pics/controlPanel-update-211125g.png"
        }
    }
}
