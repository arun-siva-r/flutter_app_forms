import 'package:get/get.dart';

import '../controllers/create_form_controller.dart';

class CreateFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateFormController>(
      () => CreateFormController(),
    );
  }
}
