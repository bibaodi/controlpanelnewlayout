import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: id_window
    objectName: "root_cp_window"
    width: 680+50
    height: 480
    visible: true
    title: qsTr("TestingControlPanel")
    ControlPanelNew {
        id: id_virtulpanel
        objectName: "virtualpanel"
    }
}
