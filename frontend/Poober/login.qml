import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtQml 2.15
/*
  Login Window of Poober, this loads first
  */
Window {
    visible: true
    width: 400
    height: 300
    title: qsTr("Poober - Login")
    id: root
    color: "#10b6e8"


    GroupBox{
        anchors.centerIn: parent
        ColumnLayout{
            anchors.fill: parent

            Text {
                 text: "Username:";
                 color: "white"
                 font.bold: true
            }
            TextField {
                id: usernameTextField
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                Keys.onReturnPressed: bLogin.clicked()
            }
            Text {
                 text: "Password:";
                 color: "white"
                 font.bold: true

            }
            TextField {
                  id: passwordTextField
                  Layout.fillWidth: true
                  echoMode: TextInput.Password
                  Layout.preferredHeight: 30
                  Keys.onReturnPressed: bLogin.clicked()

            }
            Button {
                width: parent.width
                id: bLogin
                text: "Login"
                onClicked: login(usernameTextField.text, passwordTextField.text)
            }
            Button {
                width: parent.width
                text: "Register"
                onClicked: {
                    //Opening register window
                    var component = Qt.createComponent("registration.qml");
                    var window    = component.createObject(root);
                    window.show();
                }
            }
        }
    }

    function login(username, password){
        //Creating HTTP request
        var req = new XMLHttpRequest();
        var url = "http://localhost:8080/user/auth";

        req.open("GET", url)

        //Adding authentication header manually
        var data = username + ":" + password;
        var encoded_data = Qt.btoa(data);
        req.setRequestHeader('Authorization','Basic ' + encoded_data);

        req.onreadystatechange=function() {
            if (req.readyState == 4 && req.status == 200) { //When request is done, and status is ok
                //Opening main window
                var component = Qt.createComponent("main.qml");
                var window    = component.createObject(root, {username: username});
                window.show();
                hide()
            }
        }
        req.send();
    }
}
