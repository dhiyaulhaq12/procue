// import 'dart:math';
// import 'package:aplikasi_pelatihan_billiard_cerdas/app/services/pose_detection_service.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
// import 'package:aplikasi_pelatihan_billiard_cerdas/app/services/pose_detection_service.dart';

// class CloseBridgeController extends GetxController {
//   final service = PoseDetectionService();
//   CameraController? cameraController;
//   List<CameraDescription> cameras = [];
//   int selectedCameraIndex = 0;
//   var isCameraInitialized = false.obs;
//   var predictedLabel = 'unknown'.obs;
//   bool isDetecting = false;

//   @override
//   void onClose() {
//     stopCamera();
//     super.onClose();
//   }

//   Future<void> startCamera() async {
//     cameras = await availableCameras();
//     await initializeCamera(selectedCameraIndex);
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
//         ResolutionPreset.medium,
//         enableAudio: false,
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
//       final WriteBuffer allBytes = WriteBuffer();
//       for (final Plane plane in image.planes) {
//         allBytes.putUint8List(plane.bytes);
//       }
//       final bytes = allBytes.done().buffer.asUint8List();

//       final inputImage = InputImage.fromBytes(
//         bytes: bytes,
//         metadata: InputImageMetadata(
//           size: Size(image.width.toDouble(), image.height.toDouble()),
//           rotation: InputImageRotation.rotation0deg,
//           format: InputImageFormat.nv21,
//           bytesPerRow: image.planes[0].bytesPerRow,
//         ),
//       );

//       final poseDetector = PoseDetector(
//         options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
//       );

//       final poses = await poseDetector.processImage(inputImage);

//       if (poses.isNotEmpty) {
//         final List<double> keypoints = [];
//         for (var lmType in PoseLandmarkType.values) {
//           final lm = poses.first.landmarks[lmType];
//           keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
//         }

//         if (keypoints.length == 99) {
//           final input = [keypoints];
//           final outputTensor = service.interpreter.getOutputTensor(0);
//           final output = List.generate(
//             1,
//             (_) => List.filled(outputTensor.shape[1], 0.0),
//           );

//           service.interpreter.run(input, output);

//           final predictions = output[0];
//           final maxIndex = predictions.indexWhere(
//             (e) => e == predictions.reduce(max),
//           );
//           if (maxIndex >= 0 && maxIndex < service.labels.length) {
//             predictedLabel.value = service.labels[maxIndex];
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('❌ Detection error: $e');
//     } finally {
//       isDetecting = false;
//     }
//   }
// }
