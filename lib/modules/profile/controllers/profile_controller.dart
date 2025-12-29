import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  // Mock Data matching image
  final rxName = ''.obs;
  final rxEmail = ''.obs;
  final rxPhone = ''.obs;
  final rxRole = ''.obs;
  final rxOrgName = ''.obs;
  final rxOrgCode = ''.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();
  
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    
    // Initial load
    _updateUser(authService.currentUser.value);

    // Listen to changes
    ever(authService.currentUser, _updateUser);
  }

  void _updateUser(User? user) {
    if (user != null) {
      rxName.value = user.name;
      rxEmail.value = user.email;
      rxRole.value = user.role;
      rxOrgName.value = user.orgName;
      rxOrgCode.value = user.orgCode;
      rxPhone.value = user.phoneNumber;
      _updateControllers();
    }
  }

  void _updateControllers() {
    nameController.text = rxName.value;
    emailController.text = rxEmail.value;
    phoneController.text = rxPhone.value;
    roleController.text = rxRole.value;
  }

  @override
  void onClose() {
    // NOTE: Commenting out disposal to prevent 'used after disposed' error 
    // when navigating while keyboard is active or during rapid transitions.
    // GetX lifecycle can sometimes trigger onClose while the View is still detaching.
    // nameController.dispose();
    // emailController.dispose();
    // phoneController.dispose();
    // roleController.dispose();
    super.onClose();
  }

  void navigateToSettings() {
    Get.toNamed(AppRoutes.SETTINGS);
  }

  void logout() {
    // Implement logout logic
    Get.offAllNamed(AppRoutes.LOGIN);
  }
  
  void editProfile() {
    // Update controllers with latest values before navigating
    _updateControllers();
    Get.toNamed(AppRoutes.EDIT_PROFILE);
  }

  Future<void> saveProfile() async {
    isSaving.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Update local state
    rxName.value = nameController.text;
    rxPhone.value = phoneController.text;
    // Email and Role are read-only
    
    isSaving.value = false;
    Get.back();
    
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor, // Use theme primary
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  void navigateToManageUsers() {
    Get.toNamed(AppRoutes.ADMIN_USER_LIST);
  }

  void navigateToChangePassword() {
    Get.toNamed(AppRoutes.SETTINGS_CHANGE_PASSWORD);
  }
}
