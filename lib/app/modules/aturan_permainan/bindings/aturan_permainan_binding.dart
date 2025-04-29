import 'package:get/get.dart';

import '../controllers/aturan_permainan_controller.dart';

class AturanPermainanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AturanPermainanController>(
      () => AturanPermainanController(),
    );
  }
}
