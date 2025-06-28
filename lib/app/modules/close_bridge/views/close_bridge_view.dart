import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_pelatihan_billiard_cerdas/app/controllers/pose_detection_controller.dart';

class CloseBridgeView extends StatelessWidget {
  const CloseBridgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PoseDetectionController('CloseBridge'));

    final screenWidth = MediaQuery.of(context).size.width;
    final cameraHeight = screenWidth * 4 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Close Bridge'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255), // Putih di atas
              Color(0xFFB3E5FC), // Biru muda di bawah
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final isInitialized = controller.isCameraInitialized.value;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  if (!isInitialized) ...[
                    _infoCard(),
                    const SizedBox(height: 24),
                    _instructionCard(),
                    const SizedBox(height: 32),
                    _startButton(controller),
                  ] else ...[
                    _cameraPreview(controller, screenWidth, cameraHeight),
                    const SizedBox(height: 16),
                    _predictionBox(controller),
                    const SizedBox(height: 8),
                    _accuracyBox(controller),
                    const SizedBox(height: 16),
                    _statusCard(controller),
                    const SizedBox(height: 12),
                    _actionButtons(controller),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/closebridge.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Teknik Close Bridge',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Teknik Close Bridge adalah salah satu teknik memegang stick biliar dengan telapak tangan yang menyentuh meja. Cocok untuk pukulan lurus dengan kontrol bola yang baik.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructionCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.blue.withOpacity(0.1),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.info_outline, color: Colors.blue, size: 32),
              SizedBox(height: 8),
              Text(
                'Instruksi Deteksi:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Tekan "Mulai Deteksi" untuk mengaktifkan kamera\n'
                '2. Posisikan tangan sesuai teknik Close Bridge\n'
                '3. Pastikan seluruh tangan terlihat di kamera\n'
                '4. Sistem akan memberikan feedback real-time',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _startButton(PoseDetectionController controller) {
    return Obx(() {
      if (!controller.isModelLoaded.value) {
        return ElevatedButton.icon(
          onPressed: null,
          icon: const SizedBox(
            width: 20,
            height: 20,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          label: const Text('Memuat Model...'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 5,
          ),
        );
      }

      return ElevatedButton.icon(
        onPressed: controller.startCamera,
        icon: const Icon(Icons.play_circle_fill),
        label: const Text('Mulai Deteksi'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 5,
        ),
      );
    });
  }

  Widget _cameraPreview(
      PoseDetectionController controller, double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: controller.cameraController == null ||
                  !controller.cameraController!.value.isInitialized
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text('Memuat kamera...'),
                    ],
                  ),
                )
              : CameraPreview(controller.cameraController!),
        ),
      ),
    );
  }

  Widget _predictionBox(PoseDetectionController controller) {
    return Obx(() {
      final label = controller.predictedLabel.value;
      final isCorrect = label == 'CloseBridge';
      final bgColor = isCorrect ? Colors.green : Colors.black87;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: bgColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Icon(isCorrect ? Icons.check_circle : Icons.search,
                color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label == 'unknown' || label.isEmpty
                    ? 'Mendeteksi posisi Close Bridge...'
                    : 'Terdeteksi: $label',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _accuracyBox(PoseDetectionController controller) {
    return Obx(() {
      final acc = controller.accuracy.value;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Row(
          children: [
            const Icon(Icons.assessment, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Akurasi: ${acc.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _statusCard(PoseDetectionController controller) {
    return Obx(() {
      final label = controller.predictedLabel.value;
      final isCorrect = label == 'CloseBridge';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: isCorrect ? Colors.green.shade50 : Colors.orange.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(isCorrect ? Icons.thumb_up : Icons.lightbulb_outline,
                    color: isCorrect ? Colors.green : Colors.orange, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isCorrect
                        ? 'Posisi Close Bridge sudah benar! 👍'
                        : 'Posisikan tangan Anda untuk Close Bridge',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isCorrect
                          ? Colors.green.shade800
                          : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _actionButtons(PoseDetectionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: controller.stopCamera,
          icon: const Icon(Icons.stop),
          label: const Text('Stop'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
        Obx(() {
          final isCorrect = controller.predictedLabel.value == 'CloseBridge';
          return ElevatedButton.icon(
            onPressed: isCorrect
                ? () async {
                    try {
                      // ✅ Ambil gambar dari kamera
                      final imageBytes = await controller.getCapturedImage();
                      if (imageBytes == null) {
                        Get.snackbar('Gagal', 'Gagal mengambil gambar');
                        return;
                      }

                      // ✅ Upload ke Cloudinary
                      final request = http.MultipartRequest(
                        'POST',
                        Uri.parse(
                            'https://api.cloudinary.com/v1_1/dyukn4qlh/image/upload'),
                      );
                      request.fields['upload_preset'] = 'riwayat';
                      request.files.add(
                        http.MultipartFile.fromBytes(
                          'file',
                          imageBytes,
                          filename:
                              'pose_${DateTime.now().millisecondsSinceEpoch}.jpg',
                        ),
                      );
                      debugPrint(
                          '📤 Upload preset: ${request.fields['upload_preset']}');
                      debugPrint('📤 Cloud URL: ${request.url}');
                      debugPrint('📤 Image bytes length: ${imageBytes.length}');

                      final response = await request.send();
                      final responseData =
                          await response.stream.bytesToString();
                      final responseJson = jsonDecode(responseData);

                      if (response.statusCode != 200) {
                        Get.snackbar(
                            'Error', 'Gagal upload gambar ke Cloudinary');
                        return;
                      }

                      final imageUrl = responseJson['secure_url'];

                      // ✅ Simpan riwayat ke backend
                      final token = GetStorage().read('access_token');
                      final historyData = {
                        'label': controller.predictedLabel.value,
                        'accuracy': controller.accuracy.value,
                        'image_url': imageUrl,
                        'timestamp': DateTime.now().toIso8601String(),
                      };
                      debugPrint('📤 Kirim ke backend: ${jsonEncode(historyData)}');


                      final saveResponse = await http.post(
                        Uri.parse('https://backend-billiard.vercel.app/riwayat'),
                        headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer $token'
                        },
                        body: jsonEncode(historyData),
                      );
                      debugPrint('📥 Respon backend: ${saveResponse.statusCode} ${saveResponse.body}');


                      if (saveResponse.statusCode == 200) {
                        Get.snackbar(
                          'Berhasil!',
                          'Posisi Close Bridge sudah benar & riwayat disimpan!',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        );
                      } else {
                        Get.snackbar(
                          'Gagal',
                          'Riwayat gagal disimpan!',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'Error',
                        'Terjadi kesalahan: $e',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                        snackPosition: SnackPosition.TOP,
                      );
                    }
                  }
                : null,
            icon: Icon(isCorrect ? Icons.check : Icons.hourglass_empty),
            label: Text(isCorrect ? 'Konfirmasi' : 'Menunggu'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? Colors.green : Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
        }),
      ],
    );
  }
}
