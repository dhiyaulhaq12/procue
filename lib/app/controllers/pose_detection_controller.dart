import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PoseDetectionController extends GetxController {
  final String targetLabel;

  PoseDetectionController(this.targetLabel);

  late Interpreter interpreter;
  late List<String> labels;
  late PoseDetector poseDetector;
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  var isCameraInitialized = false.obs;
  var isModelLoaded = false.obs;
  var predictedLabel = 'unknown'.obs;
  var isDetecting = false;

  var correctCount = 0.obs;
  var totalCount = 0.obs;
  var accuracy = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  @override
  void onClose() {
    stopCamera();
    interpreter.close();
    poseDetector.close();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      final labelData = await rootBundle.loadString('assets/labels/label.txt');
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      poseDetector = PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
      );
      isModelLoaded.value = true;
      debugPrint('✅ Model dan label berhasil dimuat');
      final inputTensor = interpreter.getInputTensor(0);
      debugPrint('Input tensor shape: ${inputTensor.shape}');
      debugPrint('Input tensor type: ${inputTensor.type}');
    } catch (e) {
      debugPrint('❌ Gagal load model: $e');
    }
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    await initializeCamera(0);
  }

  Future<void> initializeCamera(int cameraIndex) async {
    try {
      final selectedCamera = cameras[cameraIndex];
      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await cameraController!.initialize();
      await cameraController!.startImageStream(processCameraImage);
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint('❌ Camera init error: $e');
    }
  }

  Future<Uint8List?> getCapturedImage() async {
  if (cameraController == null || !cameraController!.value.isInitialized) {
    debugPrint("❌ Kamera belum siap");
    return null;
  }

  try {
    final XFile file = await cameraController!.takePicture();
    return await file.readAsBytes();
  } catch (e) {
    debugPrint("❌ Gagal ambil gambar: $e");
    return null;
  }
}

Future<void> saveRiwayat(String label, double acc, Uint8List imageBytes) async {
  try {
    // Upload ke Cloudinary
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/YOUR_CLOUD_NAME/image/upload'),
    );
    request.fields['upload_preset'] = 'YOUR_UPLOAD_PRESET';
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'pose_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final jsonRes = jsonDecode(responseData);

    if (response.statusCode != 200) {
      Get.snackbar("Error", "Gagal upload gambar ke Cloudinary");
      return;
    }

    final imageUrl = jsonRes['secure_url'];

    // Simpan ke backend
    final token = GetStorage().read('access_token');
    final body = jsonEncode({
      "label": label,
      "accuracy": acc,
      "image_url": imageUrl,
      "timestamp": DateTime.now().toIso8601String(),
    });

    final backendRes = await http.post(
      Uri.parse('https://your-backend-url.com/api/riwayat'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (backendRes.statusCode == 200) {
      Get.snackbar("Berhasil", "Riwayat tersimpan!", backgroundColor: Colors.green, colorText: Colors.white);
    } else {
      Get.snackbar("Gagal", "Riwayat gagal disimpan!", backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    Get.snackbar("Error", "Terjadi error: $e", backgroundColor: Colors.red, colorText: Colors.white);
  }
}

  Future<void> stopCamera() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
  }

  void processCameraImage(CameraImage image) async {
    if (isDetecting || !isModelLoaded.value) return;
    isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (final Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final rotation = InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation0deg;

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);

      if (poses.isNotEmpty) {
        final pose = poses.first;
        final keypoints = <double>[];

        for (var type in PoseLandmarkType.values) {
          final lm = pose.landmarks[type];
          keypoints.addAll(lm != null ? [lm.x, lm.y] : [0.0, 0.0]);
        }

        if (keypoints.length != 66) {
          debugPrint(
              "❌ Keypoints tidak sesuai input model: ${keypoints.length}");
          return;
        }

        final input = List.generate(
          1,
          (_) => List.generate(
            11,
            (i) => List.generate(
              6,
              (j) => [keypoints[i * 6 + j]],
            ),
          ),
        );

        final outputTensor = interpreter.getOutputTensor(0);
        final output =
            List.generate(1, (_) => List.filled(outputTensor.shape[1], 0.0));

        interpreter.run(input, output);

        final predictions = output[0];
        final maxIndex =
            predictions.indexWhere((e) => e == predictions.reduce(max));

        if (maxIndex >= 0 && maxIndex < labels.length) {
          final maxScore = predictions[maxIndex];
          final detected = labels[maxIndex].trim();
          final expected = targetLabel.trim();
          totalCount.value++;

          if (detected.toLowerCase() == expected.toLowerCase()) {
            correctCount.value++;
            predictedLabel.value = detected;
            debugPrint("✅ Detected target: $detected, Score: $maxScore");
          } else {
            predictedLabel.value = 'unknown';
            debugPrint(
                "⚠️ Detected: $detected (score: $maxScore), bukan target ($targetLabel)");
          }

          accuracy.value = (correctCount.value / totalCount.value) * 100;
          debugPrint("📊 Accuracy: ${accuracy.value.toStringAsFixed(2)}%");
          debugPrint("🎯 Detected=$detected, Target=$targetLabel");
        }
      } else {
        predictedLabel.value = 'No pose detected';
      }
    } catch (e) {
      debugPrint("❌ Detection error: $e");
    } finally {
      await Future.delayed(const Duration(milliseconds: 150));
      isDetecting = false;
    }
  }
}
