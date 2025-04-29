import 'package:get/get.dart';

import '../controllers/kamus_biliard_controller.dart';

class KamusBiliardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KamusBiliardController>(
      () => KamusBiliardController(),
    );
  }
}
