import 'package:flutter/material.dart';
import 'package:flutter_mobile/Widgets/Home.dart';
import 'package:flutter_mobile/Widgets/Login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _App createState() => _App();
}

Future<bool> isTokenValid() async {
  final storage = FlutterSecureStorage();
  print("Verifying token...");
  String? token = await storage.read(key: "token");
  print(token);
  if (token != null) {
    bool isValid = true;
    if (isValid) {
      return true;
    } else {
      return false;
    }
  }
  return false;
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
