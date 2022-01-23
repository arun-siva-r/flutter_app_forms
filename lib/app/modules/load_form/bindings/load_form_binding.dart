import 'package:get/get.dart';

import '../controllers/load_form_controller.dart';

class LoadFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoadFormController>(
      () => LoadFormController(),
    );
  }
}
