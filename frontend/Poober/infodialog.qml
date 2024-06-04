import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.15

/*
  Simple dialog window for showing information about the app.
*/
ApplicationWindow {
    title: "Poober - Info"
    id: infowindow
    GroupBox{
        anchors.margins: 50
        anchors.centerIn: parent
        Text{
            font.pointSize: 12
            text: "This app was created by:\n Lukács Tamás\n Hain Balázs Márk\n Bankó Márton Bendegúz\n as homework for \"Alkalmazásfejlesztési környezetek.\"\n\n We hope you enjoy using this app!"
        }
    }
    onClosing: hide()
}
