import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.15
import QtCharts 2.15

/*
  Main application window, containg four tabs, and a menu.

*/
ApplicationWindow {
    width: 740
    height: 480
    visible: true
    title: qsTr("Poober")
    id: mainwindow

    property string username: ""

    //Menubar at the top, containing an Exit and and Info field
    menuBar: MenuBar {
            Menu {
                title: "&Menu"
                id: menu
                MenuItem {
                    text: "&Exit"
                    onTriggered: {
                        Qt.quit()
                    }
                }
                MenuItem{
                    text: "&Info"
                    onTriggered: {
                        //Creating info dialog and showing it
                        var component = Qt.createComponent("infodialog.qml");
                        var window    = component.createObject();
                        window.show();
                    }
                }

            }
        }

    //Item containging all four tabs
    TabView {
        anchors.fill: parent
        Tab {
            title: "Book a WC"
            RowLayout {
                id: baseGrid
                anchors.fill: parent
                anchors.margins: margin

                //Item that shows details of wc that the user clicked on
                GroupBox {
                    id: wc_right_holder
                    Layout.fillHeight: true
                    width: 200
                    visible: false
                    ScrollView
                    {
                        Layout.fillHeight: true
                        anchors.fill: parent
                        clip: true

                        ColumnLayout {
                            id: wc_right
                            width: 200

                            Image {
                                id: wc_image
                                verticalAlignment: Image.AlignVCenter
                                Layout.maximumHeight: 150
                                fillMode: Image.PreserveAspectCrop
                                source: "pics/toilet_placeholder.jpg"
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                smooth: true
                                mipmap: false
                                clip: true
                            }
                            Text {
                                id: book_title
                                text: qsTr("Book this toilet!")
                                font.pixelSize: 16
                            }
                            Text {
                                id: book_addr_t
                                text: qsTr("Address")
                                font.pixelSize: 12
                                font.bold: true
                            }
                            Text {
                                id: book_addr_f
                                text: qsTr("1106 Bp., Gyakorló utca 12")
                                font.pixelSize: 12
                            }
                            Text {
                                id: book_comment_t
                                text: qsTr("Additional information:")
                                font.pixelSize: 12
                                font.bold: true
                            }
                            Text {
                                id: book_comment_f
                                Layout.preferredWidth: 200
                                Layout.maximumWidth: 200
                                //Layout.fillWidth: true
                                text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. "
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap

                                maximumLineCount: 100
                            }
                            Text {
                                id: book_features_t
                                text: "Features"
                                font.pixelSize: 12
                                font.bold: true
                            }
                            CheckBox {
                                id:ch_aroma
                                checked: true
                                text: qsTr("Aroma diffuser")
                                enabled: false
                            }
                            CheckBox {
                                id: ch_ambient
                                text: qsTr("Ambient lights")
                                enabled: false
                            }
                            CheckBox {
                                id: ch_bidet
                                checked: true
                                text: qsTr("Bidet")
                                enabled: false
                            }
                            CheckBox {
                                id: ch_bodyweight
                                checked: true
                                text: qsTr("Body measuring device")
                                enabled: false
                            }
                            CheckBox {
                                id: ch_quality_paper
                                text: qsTr("Premium quality toilet paper")
                                enabled: false
                            }
                            CheckBox {
                                id: ch_heated_floor
                                checked: true
                                text: qsTr("Heated floor")
                                enabled: false
                            }
                            Text {
                                id: book_price_t
                                font.bold: true
                                text: qsTr("Price")
                            }Text {
                                id: book_price_f
                                text: qsTr("550 HUF")
                            }
                            Button {
                                property int wcid: 0
                                id: book_button
                                text: "BOOK"
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                onClicked: function() {
                                    console.log("Button")
                                    var req = new XMLHttpRequest();
                                    var url = "http://localhost:8080/registry/id/" + wcid +"/reserve";
                                    console.log(url)
                                    req.open("GET", url)
                                    req.onreadystatechange=function() {
                                        if (req.readyState == 4 && req.status == 200) {
                                            console.log(req.responseText)
                                            parse_data(req.responseText)
                                        }
                                    }
                                    req.send();
                                }
                            }

                        }
                    }
                }

                //The list of all the available wc, user can click on them
                GroupBox
                {
                    id: groupBox
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ListView {
                        id: eventLog
                        anchors.fill: parent
                        anchors.margins: 10
                        delegate: GroupBox { //using delegate-model structure
                            anchors.left: parent.left
                            anchors.right: parent.right

                            property int idd: 0

                            Row {
                                id: row2
                                //property int idLOL: index
                                property int idLOL: wcid
                                Image {
                                    width: 50
                                    fillMode: Image.PreserveAspectFit
                                    source: "pics/toilet_placeholder.jpg"
                                }
                                Text {
                                    text: address
                                    width: 230
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.bold: true
                                }
                                Text {
                                    text: price
                                    anchors.verticalCenter: parent.verticalCenter
                                    font.bold: true
                                }
                                spacing: 10

                            }


                            MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                         // Filling details area with  actual data
                                         var req = new XMLHttpRequest();
                                         var url = "http://localhost:8080/registry/id/" + (row2.idLOL);

                                        req.open("GET", url)

                                         req.onreadystatechange=function() {
                                             if (req.readyState == 4 && req.status == 200) {
                                                 console.log(req.responseText)

                                                 var obj = JSON.parse(req.responseText);
                                                 console.log(obj)
                                                 book_addr_f.text = obj.location
                                                 book_comment_f.text = obj.properties
                                                 book_price_f.text = obj.price + " HUF"
                                                 book_button.wcid = obj.id
                                                 wc_right_holder.visible = true
                                                 ch_aroma.checked = obj.f1
                                                 ch_ambient.checked = obj.f2
                                                 ch_bidet.checked = obj.f3
                                                 ch_bodyweight.checked = obj.f4
                                                 ch_quality_paper.checked = obj.f5
                                                 ch_heated_floor.checked = obj.f6


                                             }
                                         }
                                        req.send();

                                            var req2 = new XMLHttpRequest();
                                            var url2 = "http://localhost:8080/user/auth";

                                            req2.open("GET", url2)

                                            req2.onreadystatechange=function() {
                                                if (req2.readyState == 4 && req2.status == 200) {
                                                    //Disable BOOK button if user is banned
                                                    var obj2 = JSON.parse(req2.responseText);
                                                    book_button.enabled = !obj2.banned;
                                                }
                                            }
                                            req2.send();

                                    }
                            }

                        }

                        //Model of previus list
                        model: ListModel {
                            id: eventLogModel
                            //Placeholder dummy data
                            ListElement {
                                //What we store about a wc in the list:
                                property int wcid: -1
                                address: "1106. Bp, Gyakorló utca 23."
                                price: "550 ft"
                                colorCode: "grey"
                            }
                            ListElement {
                                property int wcid: -1
                                address: "1149. Bp, Róna utca 57."
                                price: "650 ft"
                                colorCode: "red"
                            }
                        }

                        Component.onCompleted: req_data();
                        onVisibleChanged: req_data();

                       function sleep(ms) {
                         return new Promise(resolve => setTimeout(resolve, ms));
                       }

                       //Query of all the WCs
                       function req_data(){
                            eventLog.sleep(2000);

                            var req = new XMLHttpRequest();
                            var url = "http://localhost:8080/registry/all";

                            req.open("GET", url)

                            req.onreadystatechange=function() {
                                if (req.readyState == 4 && req.status == 200) {
                                    console.log(req.responseText)
                                    parse_data(req.responseText)
                                }
                            }
                            req.send();
                        }

                        //Parsing incoming data, appending model of the list
                        function parse_data(json){
                            var obj = JSON.parse(json);
                            eventLogModel.clear()
                            obj.forEach(
                                function(entry){
                                    eventLogModel.append({wcid: entry.id,
                                                          address: entry.location,
                                                          price: entry.price + " ft",
                                                          colorCode: "grey"});
                                }
                                );
                        }
                    }
                }

            }

        }

        //Tab containing information about the user
        Tab {
            title: "My Profile"
            id: prof_tab
            RowLayout {
                id: prof_row
                anchors.fill: parent
                GroupBox{
                    id: prof_left
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    property int uid: 0
                    ColumnLayout{
                        Row{
                            Text{
                                text: "Name: "
                                font.bold: true
                            }
                            Text {
                                id: prof_name
                                text: qsTr("Teszt Ferenc")
                            }
                        }
                        Row{
                            Text{
                                text: "Email: "
                                font.bold: true
                            }
                            Text {
                                id: prof_email
                                text: qsTr("tesztferenc@gmail.com")
                            }
                        }
                        Row {
                            Text{
                                text: "Balance: "
                                font.bold: true
                            }
                            Text {
                                id: prof_balance
                                text: "25600 Ft"
                            }
                        }
                        Row {
                            Text{
                                text: "Status: "
                                font.bold: true
                            }
                            Text {
                                id: prof_status
                                text: "Active"
                            }
                        }
                        Text{
                            text: "Top up your balance"
                            font.bold: true
                        }
                        Row{
                            TextField {
                                id: in_topup_amount
                                width: 80
                                height: 20
                                placeholderText: qsTr("Type the amount")
                                font.pixelSize: 12
                            }
                            Button {
                                id: btn_topup
                                text: "Submit"
                                onClicked: function(){
                                    var amount = parseInt(in_topup_amount.text)
                                    var userid = prof_left.uid

                                    var http = new XMLHttpRequest()
                                    var url = "http://localhost:8080/registry/topup";


                                    var params = "amount=" + amount;
                                    console.log(params)
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

                                }
                            }
                        }
                    }
                    Component.onCompleted: req_data2()
                    onVisibleChanged: req_data2()

                    function req_data2(){
                        var req = new XMLHttpRequest();
                        var url = "http://localhost:8080/user/auth";

                        req.open("GET", url)

                        req.onreadystatechange=function() {
                            if (req.readyState == 4 && req.status == 200) {
                                console.log(req.responseText)
                                parse_data2(req.responseText)
                            }
                        }
                        req.send();
                    }
                    function parse_data2(json){
                        var obj = JSON.parse(json);
                        prof_name.text = obj.name
                        prof_email.text = obj.email
                        prof_left.uid = obj.id
                        console.log("obj.banned: "+obj.banned)
                        prof_status.text = (obj.banned?"Banned":"Active")
                        console.log("statuslabel: "+ prof_status.text)
                        console.log(prof_left.uid)
                    }

                }

                GroupBox{
                    id: prof_right
                    Layout.fillHeight: true
                    Layout.minimumWidth: 370

                    ColumnLayout{
                        id: prof_right_col
                        width: parent.width
                        height: parent.height
                        GroupBox {
                            id: prof_no_booked
                            visible: true
                            Layout.fillWidth: true
                            Layout.minimumHeight: 220
                            ColumnLayout {
                                Text {
                                    text: qsTr("ACTIVE TRANSACTION")
                                }
                                Text {
                                    
                                    text: "Currently you have not booked a WC"
                                }
                              Button{
                                    text: "Refresh"
                                    onClicked: prof_right_col.refresh_myprofile()
                                }


                            }
                        }
                        GroupBox {
                            Layout.fillWidth: true
                            Layout.minimumHeight: 220
                            id: prof_booked
                            visible: false
                            ColumnLayout {
                                Text {
                                    text: qsTr("ACTIVE TRANSACTION")
                                }
                                Text {
                                    text: qsTr("You have 1 active reservation")
                                }
                                Row{
                                    Text {
                                        text: "ID:   "
                                    }
                                    Text {
                                        id: res_id
                                        text: "#098"
                                    }
                                }
                                Row{
                                    Text {
                                        text: "Address:   "
                                    }
                                    Text {
                                        id: res_addr
                                        text: "1106 Bp., Gyakorló utca 12."
                                    }
                                }
                                Row{
                                    Text {
                                        text: "At:   "
                                    }
                                    Text {
                                        id: res_time
                                        text: "2021. 05. 12. 12.00"
                                    }
                                }

                                Text {
                                    id: res_status
                                    text: "Reservation status:   "
                                }
                                Row {
                                    anchors.top: res_status.bottom
                                    Column {
                                        Rectangle{
                                            id: rect_ph1
                                            width: 90
                                            height: 20
                                            color: "grey"
                                            anchors.rightMargin: 20
                                        }
                                        Text{
                                            anchors.left: rect_ph3.horizontalCenter
                                            anchors.right: rect_ph3.horizontalCenter
                                            anchors.top:rect_ph3.bottom
                                            text: "Reserved"
                                        }


                                    }
                                    Column{
                                        Rectangle{
                                            id: rect_ph2
                                            width: 90
                                            height: 20
                                            color: "blue"
                                            anchors.left: rect_ph1.right
                                            anchors.leftMargin: 20
                                        }
                                        Text{
                                            anchors.left: rect_ph2.horizontalCenter
                                            anchors.right: rect_ph2.horizontalCenter
                                            anchors.top:rect_ph2.bottom
                                            text: "In use"
                                        }
                                    }
                                    Column {
                                        Rectangle{
                                            id: rect_ph3
                                            width: 90
                                            height: 20
                                            color: "grey"
                                            anchors.left: rect_ph2.right
                                            anchors.leftMargin: 20
                                        }
                                        Text{
                                            anchors.left: rect_ph3.horizontalCenter
                                            anchors.right: rect_ph3.horizontalCenter
                                            anchors.top:rect_ph3.bottom

                                            text: "Finished"
                                        }
                                    }
                                }
                            }
                        }
                        GroupBox {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            ColumnLayout{
                                ChartView {
                                    id: lineChart
                                    visible: false
                                    width: 300
                                    height: 200
                                    LineSeries {
                                        id: lineData
                                        name: "Napi költségek"
                                        XYPoint {
                                            x: 0
                                            y: 2
                                        }

                                        XYPoint {
                                            x: 1
                                            y: 1.2
                                        }

                                        XYPoint {
                                            x: 2
                                            y: 3.3
                                        }

                                        XYPoint {
                                            x: 5
                                            y: 2.1
                                        }
                                    }
                                }

                            }

                        }
                        onVisibleChanged:refresh_myprofile()

                        function refresh_myprofile(){
                            var reservation = false
                            var wcid = null
                            var addr = null
                            var time = null
                            var at = null
                            var ownerid = null

                            var req = new XMLHttpRequest();
                            var url = "http://localhost:8080/registry/myreservation";
                            console.log(url)

                            req.open("GET", url)

                            req.onreadystatechange=function() {
                                if (req.readyState == 4 && req.status == 200) {

                                    console.log("printing reservation")
                                    console.log(req.responseText)
                                    var obj = JSON.parse(req.responseText)
                                    if(obj.wcId != -1){
                                        console.log("ez minusz egy?: " + obj.wcId)
                                        reservation = true
                                        wcid = obj.wcId
                                        res_id.text = "#" + wcid
                                        time = obj.firstOpen
                                        at = obj.start
                                        console.log(at)

                                        var req9 = new XMLHttpRequest();
                                        url = "http://localhost:8080/registry/id/" + wcid;


                                        req9.open("GET", url)

                                        req9.onreadystatechange=function() {
                                            if (req9.readyState == 4 && req9.status == 200) {
                                                console.log(req.responseText)
                                                obj = JSON.parse(req.responseText)
                                                console.log("location: " + obj.location)
                                                res_addr.text = obj.location


                                            }
                                        }
                                        req9.send();


                                        prof_booked.visible = true
                                        prof_no_booked.visible = false

                                        if(time == null | time == ""){
                                            console.log("at: " + at)
                                            res_time.text = at
                                            rect_ph1.color = "blue"
                                            rect_ph2.color = "grey"
                                        } else{
                                            console.log("time: " + time)
                                            res_time.text = time
                                            rect_ph1.color = "grey"
                                            rect_ph2.color = "blue"
                                        }

                                    }
                                    else {
                                        console.log("ez minusz egy?: " + obj.wcId)
                                        reservation = false
                                        console.log("no reservation")
                                        prof_booked.visible = false
                                        prof_no_booked.visible = true
                                    }


                                }
                            }
                            req.send();

                            var req8 = new XMLHttpRequest();
                            url = "http://localhost:8080/user/auth";


                            req8.open("GET", url)

                            req8.onreadystatechange=function() {
                                if (req8.readyState == 4 && req8.status == 200) {
                                    console.log(req8.responseText)
                                    var obj2 = JSON.parse(req8.responseText)

                                    ownerid = obj2.id

                                    var req7 = new XMLHttpRequest();
                                    url = "http://localhost:8080/billing/balance/" + ownerid;


                                    req7.open("GET", url)

                                    req7.onreadystatechange=function() {
                                        if (req7.readyState == 4 && req7.status == 200) {
                                            console.log(req7.responseText)
                                            prof_balance.text = req7.responseText
                                        }
                                    }
                                    req7.send();

                                    // drawing lineChart
                                    var req2 = new XMLHttpRequest();
                                    url = "http://localhost:8080/billing/invoice/" + ownerid;
                                    console.log(url)


                                    req2.open("GET", url)

                                    req2.onreadystatechange=function() {
                                        if (req2.readyState == 4 && req2.status == 200) {
                                            console.log("Editing linechart")
                                            console.log(req2.responseText)
                                            lineData.clear()
                                            var obj3 = JSON.parse(req2.responseText)
                                            var sum_price = 0
                                            var date = ""
                                            var day = 1
                                            var max_price = 0
                                            for(var i = 0; i < obj3.length; i++){
                                                console.log("printing invoice")
                                                var invoice = obj3[i]
                                                console.log(invoice)
                                                if(date == ""){
                                                    date = invoice.date.substring(0, 10)
                                                }
                                                if(date == invoice.date.substring(0, 10)){
                                                    sum_price += parseInt(invoice.price)
                                                }
                                                else {
                                                    console.log(day)
                                                    console.log(sum_price)
                                                    lineData.append(day,sum_price)
                                                    if(sum_price > max_price){
                                                        max_price = sum_price
                                                    }
                                                    day +=1
                                                    date = invoice.date.substring(0, 10)
                                                    sum_price = parseInt(invoice.price)
                                                }
                                            }
                                            console.log(day)
                                            console.log(sum_price)
                                            if(sum_price > max_price){
                                                max_price = sum_price
                                            }
                                            lineData.append(day,sum_price)
                                            //lineData.append(2, 1000)
                                            //lineData.append(3, 3260)
                                            lineData.axisX.min = 1
                                            lineData.axisX.max = day+3
                                            lineData.axisY.min = 0
                                            lineData.axisY.max = max_price+100
                                            lineChart.visible = true

                                        }
                                    }
                                    req2.send();
                                }
                            }
                            req8.send();
                        }
                    }
                }
            }

        }

        //Tab containg information about the WC that the user is offering to the market
        Tab {
            title: "My WCs"

            ColumnLayout{
                id: mytab

                //If the user has no WC, then this item is shown, offering a way to add a WC
                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: mywc_no
                    visible: false
                    ColumnLayout{
                        Text {
                            text: "Currently you have no WCs for rent."
                            }
                        Row {
                            Text {
                                text: "Click here to add a new one"
                                }
                            Button {
                                id: btn_add_wc
                                text: "Add"

                                onClicked: {
                                        //New WC is created in new window, this is loaded here
                                        var component = Qt.createComponent("newwc.qml");
                                        var window    = component.createObject();
                                        window.show();
                                }
                            }
                        }


                    }

                }
                //If user has a WC, this item is shown
                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    id: mywc_yes
                    visible: true

                    //All details about the WC listed here
                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Text {
                            text: "You have a WC for rent. Here is its details:"
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
                                        TextEdit {
                                            readOnly: true;
                                            id: book_addr_f_d
                                            text: qsTr("1106 Bp., Gyakorló utca 12")
                                            font.pixelSize: 12
                                        }
                                        Text {
                                            id: book_comment_t_d
                                            text: qsTr("Additional information:")
                                            font.pixelSize: 12
                                            font.bold: true
                                        }
                                        TextEdit {
                                            readOnly: true
                                            id: book_comment_f_d
                                            Layout.preferredWidth: 350
                                            Layout.maximumWidth: 350
                                            width: 350
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
                                            id:ch_aroma_d
                                            checked: true
                                            text: qsTr("Aroma diffuser")
                                            enabled: false
                                        }
                                        CheckBox {
                                            id: ch_ambient_d
                                            text: qsTr("Ambient lights")
                                            enabled: false
                                        }
                                        CheckBox {
                                            id: ch_bidet_d
                                            checked: true
                                            text: qsTr("Bidet")
                                            enabled: false
                                        }
                                        CheckBox {
                                            id: ch_bodyweight_d
                                            checked: true
                                            text: qsTr("Body measuring device")
                                            enabled: false
                                        }
                                        CheckBox {
                                            id: ch_quality_paper_d
                                            text: qsTr("Premium quality toilet paper")
                                            enabled: false
                                        }
                                        CheckBox {
                                            id: ch_heated_floor_d
                                            checked: true
                                            text: qsTr("Heated floor")
                                            enabled: false
                                        }
                                    }
                                }


                                Text {
                                    id: book_price_t_d
                                    font.bold: true
                                    text: qsTr("Price")
                                }
                                Row{
                                    TextEdit {
                                        readOnly: true
                                        id: book_price_f_d
                                        text: qsTr("550")

                                    }
                                    Text {
                                        text: qsTr(" Ft")
                                    }
                                }

                                //Buttons that can toggle different actions
                                //Edit button makes the detail fields editable, so user can change own WC properties
                                //Save button makes details fields uneditable, and saves the state of properties to the backend
                                //Delete button deletes the users WC, on the backend as well
                                Row {
                                    id: buttonrow;
                                    Button {
                                        text: "Edit"
                                        onClicked: buttonrow.changeable(true)
                                    }
                                    Button {
                                        text: "Save"
                                        onClicked: {
                                            buttonrow.changeable(false)
                                            buttonrow.post_save()
                                        }
                                    }
                                    Button {
                                        text: "Delete"
                                        onClicked: {
                                            buttonrow.delete_own_wc()
                                            mywc_no.visible = true;
                                            mywc_yes.visible = false;
                                        }
                                    }

                                    //Edit property change
                                    //Parameter: true - Should be able to change, false - no changing
                                    function changeable(bool){
                                        book_price_f_d.readOnly = !bool;
                                        book_addr_f_d.readOnly = !bool;
                                        book_comment_f_d.readOnly = !bool;
                                        ch_ambient_d.enabled = bool;
                                        ch_aroma_d.enabled = bool;
                                        ch_bidet_d.enabled = bool;
                                        ch_bodyweight_d.enabled = bool;
                                        ch_quality_paper_d.enabled = bool;
                                        ch_heated_floor_d.enabled = bool;
                                    }

                                    //Sending delete request of users wc
                                    function delete_own_wc(){
                                        var http = new XMLHttpRequest()
                                        var url = "http://localhost:8080/registry/delete";
                                        http.open("DELETE", url);

                                        http.onreadystatechange = function() { // Call a function when the state changes.
                                            if (http.readyState == 4) {
                                                if (http.status == 200) {
                                                    console.log("delete ok")
                                                } else {
                                                    console.log("error while deleting: " + http.status)
                                                }
                                            }
                                        }
                                        http.send();
                                    }


                                    //Request saving user's WC's details to backend
                                    function post_save(){
                                        var http = new XMLHttpRequest()
                                        var url = "http://localhost:8080/registry/update";

                                        var location = book_addr_f_d.text
                                        var price = parseInt(book_price_f_d.text)
                                        var desc = book_comment_f_d.text
                                        var f1 = ch_aroma_d.checked
                                        var f2 = ch_ambient_d.checked
                                        var f3 = ch_bidet_d.checked
                                        var f4 = ch_bodyweight_d.checked
                                        var f5 = ch_quality_paper_d.checked
                                        var f6 = ch_heated_floor_d.checked

                                        var params = "location=" + location + "&price=" + price +"&properties=" + desc + "&f1=" + f1 + "&f2=" +f2 + "&f3=" +f3 + "&f4=" +f4 + "&f5=" +f5 + "&f6=" +f6;
                                        http.open("PUT", url);
                                        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                        http.setRequestHeader("Content-length", params.length);

                                        http.onreadystatechange = function() { // Call a function when the state changes.
                                            if (http.readyState == 4) {
                                                if (http.status == 200) {
                                                    console.log("update ok")
                                                } else {
                                                    console.log("error while updating: " + http.status)
                                                }
                                            }
                                        }
                                        http.send(params);
                                    }
                                }


                            }

                }

                //Loading data of users WC
                Component.onCompleted: req_data3()
                onVisibleChanged: req_data3()

                function req_data3(){
                    var req = new XMLHttpRequest();
                    var url = "http://localhost:8080/registry/mywc";

                    req.open("GET", url)

                    req.onreadystatechange=function() {
                        if (req.readyState == 4 && req.status == 200) {
                            console.log(req.responseText)
                            parse_data3(req.responseText)
                        }
                    }
                    req.send();
                }

                //Parsing return data, showing appropriate window (has WC or not)
                //and filling window with WC data
                function parse_data3(json){
                    var obj = JSON.parse(json);
                    if(obj == null){
                        mywc_no.visible = true;
                        mywc_yes.visible = false;
                    } else {
                        mywc_no.visible = false;
                        mywc_yes.visible = true;

                        book_addr_f_d.text = obj.location
                        book_price_f_d.text = obj.price
                        book_comment_f_d.text = obj.properties
                        ch_aroma_d.checked = obj.f1
                        ch_ambient_d.checked = obj.f2
                        ch_bidet_d.checked = obj.f3
                        ch_bodyweight_d.checked = obj.f4
                        ch_quality_paper_d.checked = obj.f5
                        ch_heated_floor_d.checked = obj.f6
                    }
                }
            }
        }

        //Admin tab
        //If user is privilaged as admin, then it shows a list of all users
        //Admin can delete a user, or send an email to their email address
        //Non-admin users only see a placeholder message, no list
        Tab {
            title: "Admin"
            id: admin_tab
            enabled: true;
            ColumnLayout{
                Layout.fillWidth: true
                Layout.fillHeight: true
                Text {
                        text: "App users:"
                }

                //Text showing if not privilaged user opens tab
                Text{
                        id: unprivilaged;
                        font.bold: true
                        text: "You do not have the privilage to view this page."
                        visible: false;
                }
                GroupBox {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    //List of users, again using delegate-model structure
                    ListView {
                        id: eventLog2
                        anchors.fill: parent
                        anchors.margins: 10
                        delegate: GroupBox {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            Row {
                                id: row3
                                anchors.left: parent.left
                                anchors.right: parent.right
                                property int idstore: userid //user's id stored in list element
                                ColumnLayout{
                                    RowLayout{
                                        //User's name and e-mail shown
                                        Text {
                                            text: uname
                                            anchors.verticalCenter: parent.verticalCenter
                                            font.bold: true
                                        }
                                        Text {
                                            text: u_email
                                            anchors.verticalCenter: parent.verticalCenter
                                            font.bold: true
                                        }
                                    }

                                    RowLayout{
                                        //Buttons to interact with user
                                        //Delete buttons removes that user
                                        //Send email button sends an email to the user containg their info
                                        Button {
                                            id: bDeleteUser
                                            text: "Delete"
                                            onClicked: {
                                                //console.log("on Clicked deletenel")
                                                bDeleteUser.deleteuser()
                                            }
                                            Component.onCompleted: {
                                                if(userid == 1)
                                                    bDeleteUser.enabled = false;
                                            }
                                            function deleteuser(){
                                                //Running delete request
                                                console.log("delete:"+row3.idstore)
                                                var req = new XMLHttpRequest();
                                                var url = "http://localhost:8080/user/delete";
                                                var param = "user_id="+row3.idstore;

                                                req.open("DELETE", url)
                                                req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                req.setRequestHeader("Content-length", param.length);

                                                req.onreadystatechange=function() {
                                                    if (req.readyState == 4 && req.status == 200) {
                                                        console.log("Delete user response:" + req.responseText)
                                                    }
                                                }
                                                req.send(param);
                                            }


                                        }
                                        Button {
                                            text: "Send e-mail"
                                            onClicked: {

                                                //Sending email request created
                                                var req = new XMLHttpRequest();
                                                var url = "http://localhost:8080/user/sendmail";
                                                var param = "userId="+row3.idstore

                                                req.open("POST", url)
                                                req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
                                                req.setRequestHeader("Content-length", param.length);

                                                req.onreadystatechange=function() {
                                                    if (req.readyState == 4 && req.status == 200) {
                                                        console.log("Mail response:" + req.responseText)
                                                    }
                                                }
                                                req.send(param);
                                            }
                                        }
                                    }
                                    spacing: 10
                                }
                            }
                        }

                        //Model of user list
                        model: ListModel {
                            id: eventLogModel2

                            //Placeholder info
                            ListElement {
                                property int userid: -1 //storing user id
                                uname: "Teszt Ferenc"
                                u_email: "Teszt Toma"
                            }
                            ListElement {
                                property int userid: -1
                                uname: "Kereszt Gyula"
                                u_email: "Pénzes Árpád"
                            }

                        }

                        //Loading data of all users on tab opening or being visible
                        Component.onCompleted: req_data4()
                        onVisibleChanged: req_data4()

                        function req_data4(){
                            var req = new XMLHttpRequest();
                            var url = "http://localhost:8080/user/all";
                            eventLogModel2.clear();

                            req.open("GET", url)

                            req.onreadystatechange=function() {
                                if (req.readyState == 4)
                                {
                                    if(req.status == 200){ //if user is admin
                                          parse_data4(req.responseText)
                                    } else { // if user is not admin
                                        unprivilaged.visible = true;
                                    }
                                }
                            }
                            req.send();
                        }

                        //Parsing data of all users, appending model of list
                        function parse_data4(json){
                            var obj = JSON.parse(json);
                            eventLogModel2.clear() //clearing placeholder or previous calls data
                            obj.forEach(
                                function(entry){
                                    eventLogModel2.append({userid: entry.id,
                                                          uname: entry.name,
                                                          u_email: entry.email});
                                }
                            );
                        }
                    }
                }
            }
        }
    }
}
