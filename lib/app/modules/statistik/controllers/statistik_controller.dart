import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatistikController extends GetxController {
  var isLoading = true.obs;
  var videoList = [].obs;

  final String apiUrl =
      'https://backend-billiard.vercel.app/videos'; // ganti ke IP jika perlu

  @override
  void onInit() {
    fetchVideos();
    super.onInit();
  }

  void fetchVideos() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        videoList.value = json.decode(response.body);
      } else {
        Get.snackbar('Error', 'Gagal mengambil data video');
      }
    } finally {
      isLoading(false);
    }
  }

  Map<String, int> getTop10ChannelCount() {
    Map<String, int> counts = {};
    for (var video in videoList) {
      final channel = video['channel'] ?? 'Unknown';
      counts[channel] = (counts[channel] ?? 0) + 1;
    }

    // Urutkan dan ambil 10 teratas
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(10));
  }

  Map<String, int> getTopWords({int limit = 10}) {
    Map<String, int> wordCounts = {};

    for (var video in videoList) {
      final title = video['title']?.toString().toLowerCase() ?? '';
      final description = video['description']?.toString().toLowerCase() ?? '';

      final combinedText = '$title $description';
      final words = combinedText
          .replaceAll(RegExp(r'[^\w\s]'), '') // hapus tanda baca
          .split(RegExp(r'\s+')); // pecah jadi kata

      for (var word in words) {
        if (word.length <= 3)
          continue; // abaikan kata pendek seperti "dan", "ini", dll
        wordCounts[word] = (wordCounts[word] ?? 0) + 1;
      }
    }

    final sorted = wordCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sorted.take(limit));
  }
}
