import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/deteksi/controllers/deteksi_controller.dart';

class DeteksiView extends GetView<DeteksiController> {
  const DeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/deteksinew.jpg',
            fit: BoxFit.cover,
          ),

          // Overlay gelap transparan
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Isi konten utama
          SafeArea(
            child: Obx(() {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Deteksi Teknik',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dropdown pilih model deteksi (telah diubah tampilannya)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: Colors.black,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        labelText: 'Pilih Model Deteksi',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      iconEnabledColor: Colors.white,
                      value: controller.activeModelFile.value.isEmpty
                          ? null
                          : controller.activeModelFile.value,
                      items: controller.modelMap.keys.map((fileName) {
                        return DropdownMenuItem(
                          value: fileName,
                          child: Center(
                            child: Text(
                              controller.modelMap[fileName]!,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.activeModelFile.value = value;
                          controller.predictedLabel.value = 'unknown';
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (!controller.isCameraInitialized.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton.icon(
                        onPressed: controller.activeModelFile.value.isEmpty
                            ? null
                            : controller.startCamera,
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text('Mulai Deteksi'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                if (controller.cameraController != null)
                                  CameraPreview(controller.cameraController!),
                                Positioned(
                                  bottom: 24,
                                  left: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      controller.predictedLabel.value != 'unknown'
                                          ? 'Detected: ${controller.predictedLabel.value}'
                                          : 'Detecting pose...',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: controller.stopCamera,
                                  icon: const Icon(Icons.stop),
                                  label: const Text('Stop'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: controller.switchCamera,
                                  icon: const Icon(Icons.flip_camera_android),
                                  label: const Text('Switch'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
