import 'dart:convert';
import 'package:http/http.dart' as http;

class SendOtpService {
  static const String _baseUrl =
      'https://earlymintbook2.conveyor.cloud/api/Authenticate/send-otp';

  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'PhoneNumber': phoneNumber}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to send OTP: ${response.body}');
    }
  }
}
