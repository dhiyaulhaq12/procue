import 'package:get/get.dart';
import 'package:aplikasi_pelatihan_billiard_cerdas/app/modules/tutorial/controllers/tutorial_controller.dart';

class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TutorialController>(() => TutorialController());
  }
}