import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobile/User.dart';
import 'package:flutter_mobile/Widgets/Login.dart';
import 'package:flutter_mobile/Widgets/Room.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../helper.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> roomWidgets = [];
  User user = User();
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
      } else {
        getUser().then((value) => user = value);
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
              id: (room)['id'] as int,
              xAxis: (room)['xAxis'] as int,
              yAxis: (room)['yAxis'] as int,
              hasSensor: (room)['hasSensor'] as bool,
              sensorId: (room)['sensorId'] as String))
          .toList();
      setState(() {});
    }
    print(roomWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome ${user.firstName} ${user.lastName}"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await storage.delete(key: "token");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              },
            ),
          ],
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
