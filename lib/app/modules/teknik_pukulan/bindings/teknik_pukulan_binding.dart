import 'package:get/get.dart';

import '../controllers/teknik_pukulan_controller.dart';

class TeknikPukulanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeknikPukulanController>(
      () => TeknikPukulanController(),
    );
  }
}
