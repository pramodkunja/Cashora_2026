import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void sendCode() {
    // Mock API call
    Get.toNamed(AppRoutes.OTP_VERIFICATION);
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
