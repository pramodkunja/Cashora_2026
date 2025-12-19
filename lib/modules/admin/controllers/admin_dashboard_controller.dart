import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class AdminDashboardController extends GetxController {
  final count = 0.obs;
  
  // Tab index for bottom bar
  final selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
    switch(index) {
      case 0:
        // Already on Dashboard
        break;
      case 1:
        Get.toNamed(AppRoutes.ADMIN_APPROVALS);
        break;
      case 2:
        // History
        break;
      case 3:
        // Profile
        break;
    }
  }

  void navigateToApprovals() {
    selectedIndex.value = 1;
    Get.toNamed(AppRoutes.ADMIN_APPROVALS);
  }
}
