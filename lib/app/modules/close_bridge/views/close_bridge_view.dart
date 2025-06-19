import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/deteksi/controllers/deteksi_controller.dart';

class CloseBridgeView extends StatelessWidget {
  const CloseBridgeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeteksiController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final cameraHeight = screenWidth * 4 / 3;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Close Bridge'),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Obx(() {
          final isInitialized = controller.isCameraInitialized.value;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                if (!isInitialized) ...[
                  _infoCard(),
                  const SizedBox(height: 32),
                  _startButton(controller),
                ] else ...[
                  _cameraPreview(controller, screenWidth, cameraHeight),
                  const SizedBox(height: 16),
                  _predictionBox(controller),
                  const SizedBox(height: 12),
                  _stopButton(controller),
                ],
                const SizedBox(height: 16),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                'assets/images/closebridge.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Teknik Close Bridge adalah salah satu teknik memegang stick biliar dengan telapak tangan yang menyentuh meja. Cocok untuk pukulan lurus dengan kontrol bola yang baik.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startButton(DeteksiController controller) {
    return ElevatedButton.icon(
      onPressed: controller.startCamera,
      icon: const Icon(Icons.play_circle_fill),
      label: const Text('Mulai Deteksi'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _cameraPreview(DeteksiController controller, double width, double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: controller.cameraController == null ||
                  !controller.cameraController!.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(controller.cameraController!),
        ),
      ),
    );
  }

  Widget _predictionBox(DeteksiController controller) {
    return Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            controller.predictedLabel.value != 'unknown'
                ? 'Terdeteksi: ${controller.predictedLabel.value}'
                : 'Sedang mendeteksi...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget _stopButton(DeteksiController controller) {
    return ElevatedButton.icon(
      onPressed: controller.stopCamera,
      icon: const Icon(Icons.stop),
      label: const Text('Stop'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
