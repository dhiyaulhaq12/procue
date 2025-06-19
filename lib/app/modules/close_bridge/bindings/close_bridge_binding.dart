import 'package:get/get.dart';
import '../controllers/close_bridge_controller.dart';

class CloseBridgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CloseBridgeController>(() => CloseBridgeController());
  }
}
