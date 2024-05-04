import 'package:shared_preferences/shared_preferences.dart';

class SharedPres {
  static Future saveRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("role", role);
  }

  static Future saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    return token;
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }
}
