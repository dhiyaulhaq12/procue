import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/deteksi/controllers/deteksi_controller.dart';
import 'package:get/get.dart';


class DeteksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeteksiController>(() => DeteksiController());
  }
}
