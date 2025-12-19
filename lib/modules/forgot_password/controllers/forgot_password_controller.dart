import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends BaseController {
  final TextEditingController inputController = TextEditingController();

  void sendOtp() async {
    final input = inputController.text.trim();
    
    if (input.isEmpty) {
      Get.snackbar('Error', 'Please enter your email or phone number');
      return;
    }

    // Basic validation for Email or Phone
    final isEmail = GetUtils.isEmail(input);
    final isPhone = GetUtils.isPhoneNumber(input);

    if (!isEmail && !isPhone) {
      Get.snackbar('Error', 'Please enter a valid email or phone number');
      return;
    }

    await performAsyncOperation(() async {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar('Success', 'OTP sent to $input');
      Get.toNamed(AppRoutes.OTP_VERIFICATION); 
    });
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }
}
