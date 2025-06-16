import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DeteksiController extends GetxController {
  Map<String, Interpreter> interpreters = {};
  CameraController? cameraController;
  List<CameraDescription> cameras = [];
  int selectedCameraIndex = 0;

  var isCameraInitialized = false.obs;
  var predictedLabel = 'unknown'.obs;
  bool isDetecting = false;

  var activeModelFile = ''.obs;

  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  final modelMap = {
    'OpenBridge.tflite': 'OpenBridge',
    'CloseBridge.tflite': 'CloseBridge',
    'RailBridge.tflite': 'RailBridge',
  };

  @override
  void onInit() {
    super.onInit();
    loadAllModels();
  }

  @override
  void onClose() {
    stopCamera();
    for (var interpreter in interpreters.values) {
      interpreter.close();
    }
    poseDetector.close();
    super.onClose();
  }

  Future<void> loadAllModels() async {
    for (var modelFile in modelMap.keys) {
      try {
        final interpreter = await Interpreter.fromAsset('assets/models/$modelFile');
        final inputShape = interpreter.getInputTensor(0).shape;
        final outputShape = interpreter.getOutputTensor(0).shape;
        debugPrint('✅ Loaded $modelFile | Input: $inputShape | Output: $outputShape');
        interpreters[modelFile] = interpreter;
      } catch (e) {
        debugPrint('❌ Failed to load model $modelFile: $e');
      }
    }
  }

  Future<void> startCamera() async {
    if (activeModelFile.value == '') {
      debugPrint('❗ Pilih model dulu sebelum mulai kamera');
      return;
    }
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
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await stopCamera();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> initializeCamera(int cameraIndex) async {
    try {
      final selectedCamera = cameras[cameraIndex];
      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
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

  void processCameraImage(CameraImage image) async {
    if (isDetecting || interpreters.isEmpty) return;
    isDetecting = true;

    try {
      List<int> allBytes = [];
      for (final plane in image.planes) {
        allBytes.addAll(plane.bytes);
      }
      final bytes = Uint8List.fromList(allBytes);

      final rotation = InputImageRotationValue.fromRawValue(
            cameraController!.description.sensorOrientation,
          ) ?? InputImageRotation.rotation0deg;

      final format = InputImageFormatValue.fromRawValue(image.format.raw);
      if (format == null) {
        debugPrint("❌ Unsupported format: ${image.format.raw}");
        isDetecting = false;
        return;
      }

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final poses = await poseDetector.processImage(inputImage);
      if (poses.isEmpty) {
        isDetecting = false;
        return;
      }

      final List<double> keypoints = [];
      for (var lmType in PoseLandmarkType.values) {
        final lm = poses.first.landmarks[lmType];
        keypoints.addAll(lm != null ? [lm.x, lm.y, lm.z] : [0.0, 0.0, 0.0]);
      }

      if (keypoints.length != 99) {
        debugPrint('❌ Keypoints tidak lengkap');
        isDetecting = false;
        return;
      }

      final interpreter = interpreters[activeModelFile.value];
      if (interpreter == null) {
        predictedLabel.value = 'unknown';
        isDetecting = false;
        return;
      }

      final inputShape = interpreter.getInputTensor(0).shape;
      final outputShape = interpreter.getOutputTensor(0).shape;

      dynamic input;
      if (inputShape.length == 2) {
        input = [keypoints];
      } else if (inputShape.length == 4) {
        input = List.generate(
          inputShape[0],
          (_) => List.generate(
            inputShape[1],
            (_) => List.generate(
              inputShape[2],
              (_) => List.filled(inputShape[3], 0.0),
            ),
          ),
        );
        for (int i = 0; i < keypoints.length && i < inputShape[2]; i++) {
          input[0][0][i][0] = keypoints[i];
        }
      } else {
        debugPrint('❌ Unsupported input shape');
        isDetecting = false;
        return;
      }

      final output = List.generate(
        outputShape[0],
        (_) => List.filled(outputShape[1], 0.0),
      );

      interpreter.run(input, output);
      final outputScores = output[0];

      debugPrint('📊 Output: $outputScores');

      final maxScore = outputScores.reduce((a, b) => a > b ? a : b);
      final modelLabel = modelMap[activeModelFile.value] ?? 'unknown';

      if (maxScore > 0.8) {
        predictedLabel.value = modelLabel;
      } else {
        predictedLabel.value = 'unknown';
      }
    } catch (e) {
      debugPrint("❌ Detection error: $e");
    } finally {
      isDetecting = false;
    }
  }
}
 