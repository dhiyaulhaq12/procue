import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/statistik/controllers/statistik_controller.dart';
import 'package:get/get.dart';

class StatistikBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatistikController>(() => StatistikController());
  }
}
