import 'package:get/get.dart';
import '../controllers/rail_bridge_controller.dart';

class RailBridgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RailBridgeController>(() => RailBridgeController());
  }
}
