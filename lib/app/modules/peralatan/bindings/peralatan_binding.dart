import 'package:get/get.dart';

import '../controllers/peralatan_controller.dart';

class PeralatanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeralatanController>(
      () => PeralatanController(),
    );
  }
}
