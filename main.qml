import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello Control Panel")

    Column {
        id: column
        x: 23
        y: 17
        width: 620
        height: 400

        Row {
            id: row0
            width: parent.width * 0.9
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (width - roundButton.width * 2)

            RoundButton {
                id: roundButton
                text: "PWR"
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
                anchors.verticalCenter: parent.verticalCenter
            }

            RoundButton {
                id: roundButton10
                anchors.top: parent.top
                text: "D"
            }

            RoundButton {
                id: roundButton11
                text: "C"
                anchors.verticalCenter: parent.verticalCenter
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
            spacing: 20

            Column {
                id: column1
                //x: parent.x
                width: 60
                height: roundButton2.height * 3
                //anchors.verticalCenter: parent.verticalCenter
                spacing: (height - roundButton13.height * 2)

                RoundButton {
                    id: roundButton13
                    text: "patient"
                    anchors.right: parent.right
                }

                RoundButton {
                    id: roundButton14
                    text: "End"
                    anchors.left: parent.left
                }
            }

            Column {
                id: column2
                //x: column1.x + column1.width + 20
                width: 60
                height: roundButton2.height * 3
                anchors.verticalCenter: parent.verticalCenter
                spacing: (height - roundButton15.height * 2)
                RoundButton {
                    id: roundButton15
                    text: "probe"
                    anchors.right: parent.right
                }

                RoundButton {
                    id: roundButton16
                    text: "arrow"
                    anchors.left: parent.left
                }
            }

            Column {
                id: column3
                width: parent.width /2.3
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter

                Row {
                    id: row_slider
                    width: parent.height
                    height: 20
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "#f00f0f"
                        border.color: "#ee7b0e"
                    }
                }
            }

            Column {
                id: column4
                //x: column5.x - width
                width: 70
                height: roundButton2.height * 5
                anchors.bottom:  parent.bottom
                spacing: (height - roundButton15.height * 2)

                RoundButton {
                    id: roundButton17
                    text: "probe"
                    anchors.right: parent.right
                }

                RoundButton {
                    id: roundButton18
                    text: "arrow"
                    anchors.left: parent.left
                }
            }

            Column {
                id: column5
                width: 60
                height: roundButton19.width*5
                spacing: (height - roundButton19.height * 3)/2

                RoundButton {
                    id: roundButton19
                    text: "zoom"
                    anchors.left: parent.left
                }

                RoundButton {
                    id: roundButton20
                    text: "focus"
                    anchors.horizontalCenter: parent.horizontalCenter
                }


                RoundButton {
                    id: roundButton21
                    text: "depth"
                    anchors.right: parent.right
                }
            }
        }
    }
}
