import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/biometric_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final rxThemeMode = 0.obs; // 0: Light, 1: Dark, 2: System
  final rxPendingThemeMode = 0.obs; // Temporary selection before saving

  // Notification Toggles
  final rxNotifyApproval = true.obs;
  final rxNotifyRequest = true.obs;
  final rxNotifyPayment = true.obs;
  final rxNotifyClarification = false.obs;

  final rxFaceIdEnabled = true.obs;

  // Change Password Controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final rxPasswordMatch = false.obs;
  final rxPasswordLength = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme();
    loadFaceIdPreference();
    
    // Listen to password changes for UI indicators
    newPasswordController.addListener(_validatePasswordRules);
    confirmPasswordController.addListener(_validatePasswordRules);
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void _validatePasswordRules() {
    rxPasswordLength.value = newPasswordController.text.length >= 8;
    rxPasswordMatch.value = newPasswordController.text.isNotEmpty && 
                           newPasswordController.text == confirmPasswordController.text;
  }

  Future<void> loadTheme() async {
    String? storedTheme = await _storage.read('theme_mode');
    if (storedTheme != null) {
      int themeIndex = int.parse(storedTheme);
      rxThemeMode.value = themeIndex;
      rxPendingThemeMode.value = themeIndex; // Sync pending
      _applyTheme(themeIndex);
    }
  }

  void selectTheme(int index) {
    rxPendingThemeMode.value = index;
  }

  void saveThemeChanges() {
    int index = rxPendingThemeMode.value;
    rxThemeMode.value = index;
    _storage.write('theme_mode', index.toString());
    _applyTheme(index);
    Get.back(); // Go back after saving
  }

  void toggleFaceId(bool value) async {
    if (value) {
      // Enabling
      final biometricService = Get.find<BiometricService>();
      if (!biometricService.isSupported.value) {
        Get.snackbar('Not Supported', 'Biometric authentication is not supported on this device.',
            backgroundColor: Colors.red.shade100, colorText: Colors.red);
        rxFaceIdEnabled.value = false;
        return;
      }
      
      bool authenticated = await biometricService.authenticate();
      if (authenticated) {
        rxFaceIdEnabled.value = true;
        _storage.write('face_id_enabled', 'true');
      } else {
        rxFaceIdEnabled.value = false; // Revert
        Get.snackbar('Authentication Failed', 'Could not enable Face ID.',
            backgroundColor: Colors.red.shade100, colorText: Colors.red);
      }
    } else {
      // Disabling
      rxFaceIdEnabled.value = false;
      _storage.write('face_id_enabled', 'false');
    }
  }

  Future<void> loadFaceIdPreference() async {
    String? enabled = await _storage.read('face_id_enabled');
    rxFaceIdEnabled.value = enabled == 'true';
  }

  void navigateToChangePassword() {
    Get.toNamed(AppRoutes.SETTINGS_CHANGE_PASSWORD);
  }

  void navigateToNotifications() {
    Get.toNamed(AppRoutes.SETTINGS_NOTIFICATIONS);
  }

  void navigateToAppearance() {
    Get.toNamed(AppRoutes.SETTINGS_APPEARANCE);
  }

  void updateTheme(int index) {
    rxThemeMode.value = index;
    _storage.write('theme_mode', index.toString());
    _applyTheme(index);
  }

  void _applyTheme(int index) {
    switch (index) {
      case 0:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 1:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 2:
        Get.changeThemeMode(ThemeMode.system);
        break;
    }
  }

  void changePassword() {
    final current = currentPasswordController.text;
    final newPass = newPasswordController.text;
    final confirm = confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'All fields are required', 
        backgroundColor: Colors.red.shade100, colorText: Colors.red);
      return;
    }

    if (newPass.length < 8) {
      Get.snackbar('Error', 'New password must be at least 8 characters', 
        backgroundColor: Colors.red.shade100, colorText: Colors.red);
      return;
    }

    if (newPass != confirm) {
      Get.snackbar('Error', 'Passwords do not match', 
        backgroundColor: Colors.red.shade100, colorText: Colors.red);
      return;
    }

    if (current == newPass) {
      Get.snackbar('Error', 'New password must be different from current password', 
        backgroundColor: Colors.red.shade100, colorText: Colors.red);
      return;
    }

    // Mock API Call
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loader
      Get.back(); // Close screen
      Get.snackbar('Success', 'Password updated successfully', 
        backgroundColor: Colors.green.shade100, colorText: Colors.green[800]);
      
      // Clear controllers
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  void logout() {
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
