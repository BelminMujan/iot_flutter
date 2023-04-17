import 'package:flutter/material.dart';
import 'package:flutter_mobile/Widgets/Home.dart';
import 'package:flutter_mobile/Widgets/Login.dart';

import 'helper.dart';

Future<void> main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _App createState() => _App();
}

class _App extends State<App> {
  // This widget is the root of your application.
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    isTokenValid().then((value) => {
          setState(() => {isLoggedIn = value})
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const Home() : const Login(),
    );
  }
}
