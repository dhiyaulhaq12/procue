import 'package:get/get.dart';

import '../controllers/edit_password_controller.dart';

class EditPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPasswordController>(
      () => EditPasswordController(),
    );
  }
}
