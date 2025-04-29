import 'package:get/get.dart';

import '../controllers/jenis_permainan_controller.dart';

class JenisPermainanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JenisPermainanController>(
      () => JenisPermainanController(),
    );
  }
}
