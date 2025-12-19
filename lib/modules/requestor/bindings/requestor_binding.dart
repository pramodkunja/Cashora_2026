import 'package:get/get.dart';

import '../controllers/requestor_controller.dart';

class RequestorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestorController>(
      () => RequestorController(),
    );
  }
}
