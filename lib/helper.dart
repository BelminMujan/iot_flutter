import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

String? url = "http://192.168.0.16:5164";

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

Future<User> getUser() async {
  var storage = FlutterSecureStorage();
  String? token = await storage.read(key: "token");

  final response = await http.get(Uri.parse("$url/auth/auto_login"), headers: {
    'Content-Type': 'application/json',
    "Accept": "application/json",
    "Authorization": "Bearer $token"
  });

  Map<String, dynamic> data = jsonDecode(response.body);
  if (data["success"] == true) {
    final u = data["data"];
    User user = User();
    user.id = u['id'];
    user.email = u['email'];
    user.firstName = u['firstName'];
    user.lastName = u['lastName'];
    return user;
  } else {
    throw Exception("No user returned");
  }
}
