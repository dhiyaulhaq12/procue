import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RiwayatController extends GetxController {
  var riwayatList = [].obs;
  final token = GetStorage().read('access_token');

  Future<void> fetchRiwayat() async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-billiard.vercel.app/riwayat'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        riwayatList.value = data['data'];
      } else {
        Get.snackbar('Error', 'Gagal memuat data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> deleteRiwayatById(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://backend-billiard.vercel.app/riwayat/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Riwayat dihapus');
        fetchRiwayat();
      } else {
        Get.snackbar('Gagal', 'Tidak dapat menghapus riwayat');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }

  Future<void> deleteAllRiwayat() async {
    try {
      final response = await http.delete(
        Uri.parse('https://backend-billiard.vercel.app/riwayat/all'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Semua riwayat dihapus');
        fetchRiwayat();
      } else {
        Get.snackbar('Gagal', 'Tidak dapat menghapus semua riwayat');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    }
  }
}
