import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.15
//import QtCharts 2.15

ApplicationWindow {
    width: 740
    height: 480
    visible: true
    title: qsTr("Add new wc")
    id: newWcWindow
    signal newWcSignal()
    signal testsignal(string msg)

    ColumnLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true

        Component.onCompleted: {
            newWcWindow.testsignal("próbacseresznye")
        }

        Text {
            text: "Enter the details of your wc:"
            }

                Image {
                    id: wc_image_d
                    verticalAlignment: Image.AlignVCenter
                    Layout.maximumHeight: 150
                    fillMode: Image.PreserveAspectCrop
                    source: "pics/toilet_placeholder.jpg"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    smooth: true
                    mipmap: false
                    clip: true
                }
                RowLayout {
                    Layout.preferredWidth: 350
                    Layout.maximumWidth: 350
                    Layout.fillHeight: true
                    Column{
                        Layout.maximumWidth: 350
                        Layout.fillHeight: true
                        Text {
                            id: book_addr_t_d
                            text: qsTr("Address")
                            font.pixelSize: 12
                            font.bold: true
                        }
                        TextInput {
                            id: add_addr_f
                            text: qsTr("1106 Bp., Gyakorló utca 12")
                            font.pixelSize: 12

                        }
                        Text {
                            id: book_comment_t_d
                            text: qsTr("Additional information:")
                            font.pixelSize: 12
                            font.bold: true
                        }
                        TextArea  {
                            id: add_comment_f
                            Layout.preferredWidth: 350
                            Layout.maximumWidth: 350
                            width: 350
                            //Layout.fillWidth: true
                            text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
                            font.pixelSize: 12
                            wrapMode: Text.WordWrap

                        }
                    }
                    Column {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            id: book_features_t_d
                            text: "Features"
                            font.pixelSize: 12
                            font.bold: true
                        }
                        CheckBox {
                            id:ch_aroma_add
                            checked: true
                            text: qsTr("Aroma diffuser")
                        }
                        CheckBox {
                            id: ch_ambient_add
                            text: qsTr("Ambient lights")
                        }
                        CheckBox {
                            id: ch_bidet_add
                            checked: true
                            text: qsTr("Bidet")
                        }
                        CheckBox {
                            id: ch_bodyweight_add
                            checked: true
                            text: qsTr("Body measuring device")
                        }
                        CheckBox {
                            id: ch_quality_paper_add
                            text: qsTr("Premium quality toilet paper")
                        }
                        CheckBox {
                            id: ch_heated_floor_add
                            checked: true
                            text: qsTr("Heated floor")
                        }
                    }
                }


                Text {
                    id: book_price_t_d
                    font.bold: true
                    text: qsTr("Price (HUF)")
                }TextEdit {
                    id: add_price_f
                    text: qsTr("550")
                }
                Row {
                    Button {
                        text: "Add"
                        onClicked: addWc()
                    }
                    Button {
                        text: "Save"
                        onClicked: model.submit()
                        visible: false
                    }
                }


            }

    function addWc(){
        var http = new XMLHttpRequest()
        var url = "http://localhost:8080/registry/add";
        /*
        location, price, desc, feautres,
        */
        var location = add_addr_f.text
        var price = add_price_f.text
        var desc = add_comment_f.text
        var f1 = ch_aroma_add.checked
        var f2 = ch_ambient_add.checked
        var f3 = ch_bidet_add.checked
        var f4 = ch_bodyweight_add.checked
        var f5 = ch_quality_paper_add.checked
        var f6 = ch_heated_floor_add.checked

        var params = "location=" + location + "&price=" + price +"&properties=" + desc + "&f1=" + f1 + "&f2=" +f2 + "&f3=" +f3 + "&f4=" +f4 + "&f5=" +f5 + "&f6=" +f6;
        http.open("POST", url, true);

        // Send the proper header information along with the request
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        http.setRequestHeader("Content-length", params.length);
        //http.setRequestHeader("Connection", "close");

        http.onreadystatechange = function() { // Call a function when the state changes.
            if (http.readyState == 4) {
                if (http.status == 200) {
                    console.log("ok")
                } else {
                    console.log("error: " + http.status)
                }
            }
        }
        http.send(params);

        newWcWindow.newWcSignal();
        newWcWindow.hide();
        }
    }
