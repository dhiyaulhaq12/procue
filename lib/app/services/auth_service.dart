import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static const baseUrl =
      'http://192.168.1.6:5000'; // Ganti sesuai IP backend kamu

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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Gagal mendaftar',
          'details': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan jaringan: $e',
      };
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

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'access_token': data['access_token'], // ambil token di sini
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ??
              'Gagal login', // di backend kamu pakai key 'message'
          'details': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan jaringan: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP berhasil diverifikasi',
        };
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'OTP tidak valid',
          'details': data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Kesalahan jaringan: $e',
      };
    }
  }
}
