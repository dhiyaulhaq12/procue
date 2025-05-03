import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class DeteksiController extends GetxController {
  // Kamera
  CameraController? cameraController;
  var isCameraInitialized = false.obs;

  // Video dari galeri
  VideoPlayerController? videoPlayerController;
  var isVideoLoaded = false.obs;

  /// Inisialisasi kamera
  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      Get.snackbar("Error", "Gagal inisialisasi kamera: $e");
    }
  }

  /// Stop kamera
  void stopCamera() {
    if (cameraController != null && isCameraInitialized.value) {
      cameraController!.dispose();
      cameraController = null;
      isCameraInitialized.value = false;
    }
  }

  /// Unggah dan putar video dari galeri
  Future<void> pickVideo() async {
    try {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);

      if (picked != null) {
        videoPlayerController?.dispose(); // Bersihkan controller lama

        videoPlayerController = VideoPlayerController.file(File(picked.path));
        await videoPlayerController!.initialize();
        isVideoLoaded.value = true;

        videoPlayerController!.play();
      } else {
        Get.snackbar("Info", "Tidak ada video dipilih");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat video: $e");
    }
  }

  /// Bersihkan semua resource saat keluar
  @override
  void onClose() {
    stopCamera();
    videoPlayerController?.dispose();
    super.onClose();
  }
}
