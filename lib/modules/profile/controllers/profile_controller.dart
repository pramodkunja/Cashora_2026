import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  // Mock Data matching image
  final rxName = 'Alex Morgan'.obs;
  final rxEmail = 'alex.morgan@company.com'.obs;
  final rxPhone = '+1 123-456-7890'.obs;
  final rxRole = 'Team Member'.obs; // Or Approver/Admin based on context

  void navigateToSettings() {
    Get.toNamed(AppRoutes.SETTINGS);
  }

  void logout() {
    // Implement logout logic
    Get.offAllNamed(AppRoutes.LOGIN);
  }
  


  void editProfile() {
    // Navigate to Admin Edit User with current user data (mocked for now)
    // In a real app, you'd pass the actual user model
    Get.toNamed(AppRoutes.ADMIN_EDIT_USER); 
  }

  void navigateToManageUsers() {
    Get.toNamed(AppRoutes.ADMIN_USER_LIST);
  }

  void navigateToChangePassword() {
    Get.toNamed(AppRoutes.SETTINGS_CHANGE_PASSWORD);
  }
}
