import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const baseUrl = 'http://192.168.5.227:5000'; // IP LOCAL PC

  static Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Gagal mendaftar, status code: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'error': 'Gagal login, status code: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      return {'error': 'Terjadi kesalahan jaringan: $e'};
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/register/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {
        'error': 'Gagal verifikasi OTP, status: ${response.statusCode}',
        'details': response.body,
      };
    }
  } catch (e) {
    return {'error': 'Kesalahan jaringan: $e'};
  }
}

}
