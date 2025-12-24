import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends BaseController {
  final AuthService _authService = Get.find<AuthService>();
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    // Unfocus keyboard to prevent 'TextEditingController used after disposed' error
    FocusManager.instance.primaryFocus?.unfocus();

    await performAsyncOperation(() async {
      await _authService.login(email, password);
      
      final user = _authService.currentUser.value;
      if (user != null) {
        if (user.role.toLowerCase() == 'admin' || user.role.toLowerCase() == 'super_admin') {
          Get.offAllNamed(AppRoutes.ADMIN_DASHBOARD);
        } else if (user.role.toLowerCase() == 'accountant') {
          Get.offAllNamed(AppRoutes.ACCOUNTANT_DASHBOARD);
        } else {
           Get.offAllNamed(AppRoutes.REQUESTOR);
        }
      } else {
         Get.offAllNamed(AppRoutes.REQUESTOR);
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
