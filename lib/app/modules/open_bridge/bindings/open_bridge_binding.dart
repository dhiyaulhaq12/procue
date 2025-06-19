import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/open_bridge/controllers/open_bridge_controller.dart';
import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/deteksi/controllers/deteksi_controller.dart';

class OpenBridgeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeteksiController>(() => DeteksiController());
    Get.lazyPut<OpenBridgeController>(() => OpenBridgeController());
  }
}
