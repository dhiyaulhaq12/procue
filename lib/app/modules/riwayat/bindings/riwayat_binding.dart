import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/riwayat/controllers/riwayat_controller.dart';

class RiwayatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RiwayatController>(() => RiwayatController());
  }
}
