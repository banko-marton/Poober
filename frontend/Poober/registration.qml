import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.3
import QtQml 2.15

/*
  Registration window, new users need to add their username, password, and e-mail address
  */

ApplicationWindow {
    id: root;
    width: 600;
    height: 400;
    color: "#10b6e8"

    GroupBox{
        anchors.margins: 10
        anchors.fill: parent
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
            }
            Text {
                 text: "Password:";
                 color: "white"
                 font.bold: true

            }
            TextField {
                  id: password1TextField
                  Layout.fillWidth: true
                  echoMode: TextInput.Password
            }
            Text {
                 text: "Password again:";
                 color: "white"
                 font.bold: true

            }
            TextField {
                //Second password field, for confirming password
                  id: password2TextField
                  Layout.fillWidth: true
                  echoMode: TextInput.Password
            }
            Text {
                 text: "E-mail:";
                 color: "white"
                 font.bold: true
            }
            TextField {
                id: emailTextField
                Layout.fillWidth: true
            }
            Button {
                width: parent.width
                text: "Register"
                onClicked: registerAccount(usernameTextField.text, password1TextField.text, password2TextField.text, emailTextField.text)
            }
        }
    }

    function registerAccount(){
        //If two passwords do not match
        if(password1TextField.text !== password2TextField.text){
            console.log("Passwords don't match!")
            return;
        }

        //Creating request for registering
        var req = new XMLHttpRequest();
        var url = "http://localhost:8080/user/register";

        //Loading params to header
        var params = "name="+usernameTextField.text+"&password="+password1TextField.text+"&email="+emailTextField.text;
        req.open("POST", url)
        req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        req.setRequestHeader("Content-length", params.length);

        req.onreadystatechange=function() {
                console.log(req.responseText);
        }
        req.send(params);
    }
}
