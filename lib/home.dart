import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:student_ble/model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResult;
  List studentList = List<Student>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addFakeStudentList();
  }

  scanDevice() {
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    // Listen to scan results
    flutterBlue.scanResults.listen((result) {
      try {
        // TODO : is not safe here to set value
        if (result.length > 0) {
          setState(() {
            scanResult = result;
          });
        }
      } catch (e) {
        log(e.toString());
      }
    });
    // Stop scanning
    flutterBlue.stopScan();
  }

  addFakeStudentList() {
    studentList = [];
    studentList.add(Student("EF:AB:3D:D5:9D:C1", "Prayuth",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/240_20190724091130000000.jpg"));
    studentList.add(Student("77:83:7B:20:50:63", "Pravit",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/234_20190724090526000000.jpg"));
    studentList.add(Student("CC:4B:73:7B:E5:5D", "Somkit",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/5_20190724090648000000.jpg"));
    studentList.add(Student("88:0F:10:A4:98:01", "Witsanu",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/236_20190724090908000000.jpg"));
    studentList.add(Student("24:0A:C4:03:C3:52", "Anutin",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/238_20190724091042000000.jpg"));
    studentList.add(Student("24:0A:C4:03:C3:54", "Autama",
        "https://media.thaigov.go.th/uploads/thumbnail/cabinet/2019/07/242_20190724091328000000.jpg"));
  }

  searchName(String id) {
    String name = "";
    studentList.forEach((data) {
      if (data.id == id) {
        name = data.name;
      }
    });
    return name;
  }

  Widget buildList(ScanResult scanResult) {
    log(scanResult.device.id.toString());
    String name = searchName(scanResult.device.id.toString());
    return ListTile(
      leading: CircleAvatar(
        child: Text(name.substring(0, 2).toUpperCase()),
      ),
      title: Text(name),
      subtitle: Text("id = " +
          scanResult.device.id.toString() +
          " rssi = " +
          scanResult.rssi.toString() +
          "dB"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Person list"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                scanDevice();
              })
        ],
      ),
      body: SafeArea(
          child: Container(
              child: (scanResult != null)
                  ? ListView.builder(
                      itemCount: scanResult.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildList(scanResult[index]);
                      },
                    )
                  : Container())),
    );
  }
}
