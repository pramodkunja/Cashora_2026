import 'package:get/get.dart';
import '../controllers/organization_setup_controller.dart';

class OrganizationSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrganizationSetupController>(() => OrganizationSetupController());
  }
}
