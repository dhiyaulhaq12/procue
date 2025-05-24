import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileController extends GetxController {
  var username = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    print('Token di profile: $token');

    if (token == null) {
      Get.snackbar('Error', 'Token tidak ditemukan');
      return;
    }

    final response = await http.get(
      Uri.parse('http://192.168.0.109:5000/user'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      username.value = data['username'];
      email.value = data['email'];
    } else {
      Get.snackbar('Gagal', 'Gagal mengambil data user');
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    Get.offAllNamed('/login');
  }
}
