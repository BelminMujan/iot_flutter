import "package:flutter/material.dart";
import "package:flutter_mobile/Widgets/Login.dart";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerForm = GlobalKey<FormState>();

  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(45, 150, 45, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _registerForm,
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
                          child: const Text('Register'),
                          onPressed: () => {
                                if (_registerForm.currentState!.validate())
                                  _registerForm.currentState?.save()
                              }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                )
              ],
            )));
  }
}
