import 'package:get/get.dart';

import '../controllers/aktifitas_login_controller.dart';

class AktifitasLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginActivityController>(
      () => LoginActivityController(),
    );
  }
}
