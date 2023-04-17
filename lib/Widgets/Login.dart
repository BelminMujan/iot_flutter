import "dart:convert";
import "package:flutter_mobile/Widgets/Home.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:http/http.dart' as http;
import "package:flutter/material.dart";
import "package:flutter_mobile/Widgets/Register.dart";

import "../helper.dart";

Future<void> login(context, email, password) async {
  print("Logging in...");
  final response = await http.post(Uri.parse("$url/auth/login"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }));
  final storage = FlutterSecureStorage();
  Map<String, dynamic> data = jsonDecode(response.body);
  if (data["success"] == true && data["token"] != null) {
    print("User logged in:");
    print(data);
    await storage.write(key: "token", value: data["token"]);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }
}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginForm = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(45, 150, 45, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _loginForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Please enter your email!";
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                          obscureText: true,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return "Please enter your password!";
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                          child: const Text('Login'),
                          onPressed: () => {
                                if (_loginForm.currentState!.validate())
                                  _loginForm.currentState?.save(),
                                login(context, _email, _password)
                              }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()));
                      },
                      child: const Text(
                        "Create one",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
