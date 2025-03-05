import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:trinhtuandan_nhom3_2180602115/config/config_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  String get apiUrl => "${Config_URL.baseUrl}Authenticate/login";
  final Logger logger = Logger();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status']) {
          String token = data['token'];
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('jwt_token', token);
          prefs.setString('userId',
              decodedToken['userId']); // Lưu userId vào SharedPreferences
          prefs.setString('username', username);

          return {
            "success": true,
            "token": token,
            "decodedToken": decodedToken
          };
        } else {
          return {"success": false, "message": data['message']};
        }
      } else {
        return {
          "success": false,
          "message": "HTTP Error: ${response.statusCode}"
        };
      }
    } catch (e) {
      logger.e("Login failed: $e");
      return {"success": false, "message": "Network error: $e"};
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    print('Token hiện tại: $token');
    return token;
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
