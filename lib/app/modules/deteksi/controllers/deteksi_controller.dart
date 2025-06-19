import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DeteksiController extends GetxController {
  late Interpreter interpreter;
  List<String> labels = [];

  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  var isCameraInitialized = false.obs;
  var predictedLabel = 'unknown'.obs;
  bool isDetecting = false;

  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  @override
  void onInit() {
    super.onInit();
    loadModelAndLabels();
  }

  @override
  void onClose() {
    stopCamera();
    interpreter.close();
    poseDetector.close();
    super.onClose();
  }

  Future<void> loadModelAndLabels() async {
    interpreter = await Interpreter.fromAsset('models/model.tflite');

    final labelTxt = await rootBundle.loadString('assets/labels/label.txt');
    labels = labelTxt.split('\n').where((e) => e.trim().isNotEmpty).toList();

    debugPrint('✅ Model dan labels dimuat');
  }

  Future<void> startCamera() async {
    cameras = await availableCameras();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> stopCamera() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
  }

  Future<void> switchCamera() async {
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await stopCamera();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> initializeCamera(int index) async {
    final selectedCamera = cameras[index];
    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );
    await cameraController!.initialize();
    await cameraController!.startImageStream(processCameraImage);
    isCameraInitialized.value = true;
  }

  void processCameraImage(CameraImage image) async {
    if (isDetecting) return;
    isDetecting = true;

    try {
      final allBytes = image.planes.expand((plane) => plane.bytes).toList();
      final bytes = Uint8List.fromList(allBytes);

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormatValue.fromRawValue(image.format.raw)!,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isNotEmpty) {
        final keypoints = <double>[];
        for (var lmType in PoseLandmarkType.values) {
          final lm = poses.first.landmarks[lmType];
          keypoints.addAll(lm != null ? [lm.x, lm.y] : [0.0, 0.0]);
        }

        if (keypoints.length == 66) {
          final input = [keypoints];
          final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);
          interpreter.run(input, output);

          final scores = output[0] as List<double>;
          final maxIdx = scores.indexWhere((e) => e == scores.reduce((a, b) => a > b ? a : b));
          final confidence = scores[maxIdx];

          if (confidence > 0.8) {
            predictedLabel.value = labels[maxIdx];
          } else {
            predictedLabel.value = 'unknown';
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error deteksi: $e');
    } finally {
      isDetecting = false;
    }
  }
}
