import 'dart:convert';
import 'package:http/http.dart' as http;

class VerifyOtpService {
  static const String _baseUrl =
      'https://earlymintbook2.conveyor.cloud/api/Authenticate/verify-otp';

  static Future<Map<String, dynamic>> verifyOtp(
      String phoneNumber, String otp) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'PhoneNumber': phoneNumber,
        'Otp': otp,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }
}
