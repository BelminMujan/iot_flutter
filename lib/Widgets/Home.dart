import 'package:flutter/material.dart';
import 'package:flutter_mobile/Widgets/Login.dart';
import 'package:flutter_mobile/Widgets/Room.dart';
import 'package:flutter_mobile/main.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      isTokenValid().then((value) => {
            if (value != true)
              {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false)
              }
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Container(
          padding: EdgeInsets.all(45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Room(temperature: 25, width: 200, height: 100),
              const SizedBox(
                height: 15,
              ),
              const Room(temperature: 20, width: 200, height: 200),
            ],
          ),
        ));
  }
}
