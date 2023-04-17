import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
