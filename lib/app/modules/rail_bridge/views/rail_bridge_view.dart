import 'package:aplikasi_pelatihan_billiard_cerdas/app/controllers/pose_detection_controller.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RailBridgeView extends StatelessWidget {
  const RailBridgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PoseDetectionController('RailBridge'));

    final screenWidth = MediaQuery.of(context).size.width;
    final cameraHeight = screenWidth * 4 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rail Bridge'),
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
                'assets/images/railbridge.jpg',
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
                    'Teknik Rail Bridge',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Rail Bridge digunakan ketika bola target sangat dekat dengan cushion (rail). Cue stick ditempatkan di atas rail untuk menstabilkan tembakan.',
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
                '2. Posisikan tangan sesuai teknik Rail Bridge\n'
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
      final isCorrect = label == 'RailBridge';
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
                    ? 'Mendeteksi posisi Rail Bridge...'
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
      final isCorrect = label == 'RailBridge';

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
                        ? 'Posisi Rail Bridge sudah benar! 👍'
                        : 'Posisikan tangan Anda untuk Rail Bridge',
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
          final isCorrect = controller.predictedLabel.value == 'RailBridge';
          return ElevatedButton.icon(
            onPressed: isCorrect
                ? () {
                    Get.snackbar(
                      'Berhasil!',
                      'Posisi Rail Bridge sudah benar!',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                      snackPosition: SnackPosition.TOP,
                    );
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
