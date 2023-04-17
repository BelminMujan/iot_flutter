import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_mobile/Widgets/Login.dart';
import 'package:flutter_mobile/Widgets/Room.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../helper.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> roomWidgets = [];
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    isTokenValid().then((value) {
      if (value != true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      }
    });
    getRooms();
  }

  void getRooms() async {
    final token = await storage.read(key: "token");
    final response = await http.get(Uri.parse("$url/api/Room/all"), headers: {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    if (data != null) {
      List<dynamic> roomList = data["data"];

      roomWidgets = roomList
          .map((room) => Room(
              temperature: 20,
              xAxis: (room)['xAxis'] as int,
              yAxis: (room)['yAxis'] as int))
          .toList();
      setState(() {});
    }
    print(roomWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: roomWidgets,
          ),
        )));
  }
}

// class RoomObject {
//   int id;
//   String title;
//   int xAxis;
//   int yAxis;
//   bool hasSensor;
//   String sensorId;

//   RoomObject(
//       {required this.id,
//       required this.title,
//       required this.xAxis,
//       required this.yAxis,
//       required this.hasSensor,
//       required this.sensorId});

//   factory RoomObject.fromJson(Map<String, dynamic> json) {
//     return RoomObject(
//         id: json['id'],
//         title: json['title'],
//         xAxis: json['xAxis'],
//         yAxis: json['yAxis'],
//         hasSensor: json['hasSensor'],
//         sensorId: json['sensorId']);
//   }
// }
