import 'dart:io';

import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/deteksi/controllers/deteksi_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class DeteksiView extends GetView<DeteksiController> {
  const DeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isCameraInitialized.value &&
            controller.cameraController != null) {
          return Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(controller.cameraController!),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    controller.stopCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Tutup Kamera"),
                ),
              ),
            ],
          );
        } else if (controller.isVideoLoaded.value &&
            controller.videoPlayerController != null &&
            controller.videoPlayerController!.value.isInitialized) {
          return Stack(
            children: [
              Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: controller.videoPlayerController!.value.size.width,
                    height: controller.videoPlayerController!.value.size.height,
                    child: VideoPlayer(controller.videoPlayerController!),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (controller
                              .videoPlayerController!.value.isPlaying) {
                            controller.videoPlayerController!.pause();
                          } else {
                            controller.videoPlayerController!.play();
                          }
                        },
                        icon: Icon(
                          controller.videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.isVideoLoaded.value = false;
                        controller.videoPlayerController?.dispose();
                        controller.videoPlayerController = null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Tutup Video"),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/deteksinew.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Deteksi Teknik',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 5,
                              color: Colors.black,
                              offset: Offset(1, 2),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          controller.initCamera();
                        },
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text("Buka Kamera"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black87,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? video = await picker.pickVideo(
                              source: ImageSource.gallery);

                          if (video != null) {
                            controller.videoPlayerController =
                                VideoPlayerController.file(File(video.path));
                            await controller.videoPlayerController!
                                .initialize();
                            controller.videoPlayerController!.play();
                            controller.isVideoLoaded.value = true;
                          } else {
                            Get.snackbar(
                                "Batal", "Tidak ada video yang dipilih");
                          }
                        },
                        icon: const Icon(Icons.video_library,
                            color: Colors.black),
                        label: const Text("Unggah Video"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
