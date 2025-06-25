// import 'dart:async';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';

// class OpenBridgeController extends GetxController {
//   late Interpreter interpreter;
//   late PoseDetector poseDetector;

//   CameraController? cameraController;
//   List<CameraDescription> cameras = [];
//   int selectedCameraIndex = 0;

//   var isCameraInitialized = false.obs;
//   var predictedLabel = 'unknown'.obs;
//   bool isDetecting = false;

//   final String modelFile = 'model.tflite';
//   final List<String> labels = [
//     'CloseBridge',
//     'OpenBridge',
//     'RailBridge'
//   ]; // urutan sesuai model

//   final String targetLabel = 'OpenBridge'; // label target untuk halaman ini

//   @override
//   void onInit() {
//     super.onInit();
//     loadModel();
//   }

//   @override
//   void onClose() {
//     stopCamera();
//     interpreter.close();
//     poseDetector.close();
//     super.onClose();
//   }

//   Future<void> loadModel() async {
//     try {
//       interpreter = await Interpreter.fromAsset('assets/models/$modelFile');
//       poseDetector = PoseDetector(
//         options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
//       );
//       debugPrint('✅ Model OpenBridge loaded');
//     } catch (e) {
//       debugPrint('❌ Failed to load model: $e');
//     }
//   }

//   Future<void> startCamera() async {
//     try {
//       cameras = await availableCameras();
//       await initializeCamera(selectedCameraIndex);
//     } catch (e) {
//       debugPrint('❌ Camera start error: $e');
//     }
//   }

//   Future<void> stopCamera() async {
//     await cameraController?.stopImageStream();
//     await cameraController?.dispose();
//     cameraController = null;
//     isCameraInitialized.value = false;
//     predictedLabel.value = 'unknown';
//   }

//   Future<void> initializeCamera(int cameraIndex) async {
//     try {
//       final selectedCamera = cameras[cameraIndex];
//       cameraController = CameraController(
//         selectedCamera,
//         ResolutionPreset.low,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//       );
//       await cameraController!.initialize();
//       await cameraController!.startImageStream(processCameraImage);
//       isCameraInitialized.value = true;
//     } catch (e) {
//       debugPrint('❌ Camera init error: $e');
//     }
//   }

//   void processCameraImage(CameraImage image) async {
//     if (isDetecting) return;
//     isDetecting = true;

//     try {
//       final bytes = _concatenatePlanes(image.planes);
//       final rotation = InputImageRotationValue.fromRawValue(
//             cameraController!.description.sensorOrientation,
//           ) ??
//           InputImageRotation.rotation0deg;

//       final format = InputImageFormatValue.fromRawValue(image.format.raw);
//       if (format == null) {
//         isDetecting = false;
//         return;
//       }

//       final inputImage = InputImage.fromBytes(
//         bytes: bytes,
//         metadata: InputImageMetadata(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           rotation: rotation,
//           format: format,
//           bytesPerRow: image.planes[0].bytesPerRow,
//         ),
//       );

//       final poses = await poseDetector.processImage(inputImage);
//       if (poses.isEmpty) {
//         await Future.delayed(const Duration(milliseconds: 150));
//         isDetecting = false;
//         return;
//       }

//       final keypoints = _extractKeypoints(poses.first);
//       if (keypoints.length != 66) {
//         debugPrint("❌ Keypoints tidak lengkap: ${keypoints.length}");
//         isDetecting = false;
//         return;
//       }

//       final input = _prepareInput(keypoints);
//       final output = _prepareOutput();

//       interpreter.run(input, output);
//       final result = output[0]; // contoh: [0.9, 0.05, 0.05]

//       final maxScore = result.reduce((a, b) => a > b ? a : b);
//       final maxIndex = result.indexOf(maxScore);
//       final predictedClass = labels[maxIndex];

//       // Cek apakah prediksi sesuai halaman
//       predictedLabel.value = predictedClass == targetLabel
//           ? '✅ Gerakan sudah benar'
//           : '❌ Gerakan belum benar';

//       debugPrint("🎯 Prediksi: $predictedClass, Skor: $maxScore");
//     } catch (e) {
//       debugPrint("❌ Error deteksi: $e");
//     } finally {
//       await Future.delayed(const Duration(milliseconds: 150));
//       isDetecting = false;
//     }
//   }

//   Uint8List _concatenatePlanes(List<Plane> planes) {
//     final allBytes = <int>[];
//     for (final plane in planes) {
//       allBytes.addAll(plane.bytes);
//     }
//     return Uint8List.fromList(allBytes);
//   }

//   List<double> _extractKeypoints(Pose pose) {
//     final keypoints = <double>[];
//     for (var type in PoseLandmarkType.values) {
//       final lm = pose.landmarks[type];
//       keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
//     }
//     return keypoints;
//   }

//   dynamic _prepareInput(List<double> keypoints) {
//     final inputShape = interpreter.getInputTensor(0).shape;

//     if (inputShape.length == 4 &&
//         inputShape[0] == 1 &&
//         inputShape[1] == 11 &&
//         inputShape[2] == 6 &&
//         inputShape[3] == 1) {
//       final input = List.generate(
//         1,
//         (_) => List.generate(
//           11,
//           (i) => List.generate(
//             6,
//             (j) => [keypoints[i * 6 + j]],
//           ),
//         ),
//       );
//       return input;
//     } else if (inputShape.length == 2) {
//       return [keypoints];
//     } else {
//       throw Exception("Unsupported input shape: $inputShape");
//     }
//   }

//   List<List<double>> _prepareOutput() {
//     return List.generate(1, (_) => List.filled(3, 0.0));
//   }
// }
