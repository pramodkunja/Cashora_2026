import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';

class OtpVerificationController extends BaseController {
  // Array of controllers for 6 inputs
  final List<TextEditingController> otpControllers = List.generate(
    6, 
    (index) => TextEditingController()
  );
  
  // Focus nodes for managing input flow
  final List<FocusNode> focusNodes = List.generate(
    6, 
    (index) => FocusNode()
  );

  final RxInt remainingSeconds = 59.obs;
  Timer? _timer;
  final RxBool canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    remainingSeconds.value = 59;
    canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOtpDigitEntered(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus(); // Done entering
        verifyOtp(); // Auto-verify (optional, but good UX)
      }
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get formattedTime {
    final minutes = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    
    // Simulate API call
    Get.snackbar('Sent', 'A new code has been sent.');
    startTimer();
  }

  Future<void> verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter a complete 6-digit code');
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
       Get.snackbar('Error', 'OTP must contain only numbers');
       return;
    }

    await performAsyncOperation(() async {
      // Simulate verification
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar('Success', 'OTP Verified!');
      Get.offNamed(AppRoutes.RESET_PASSWORD);
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var c in otpControllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.onClose();
  }
}
