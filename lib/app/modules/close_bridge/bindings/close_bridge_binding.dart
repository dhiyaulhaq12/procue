import 'package:get/get.dart';
import '../../../controllers/pose_detection_controller.dart';

class CloseBridgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoseDetectionController>(() => PoseDetectionController('CloseBridge'));
  }
}
