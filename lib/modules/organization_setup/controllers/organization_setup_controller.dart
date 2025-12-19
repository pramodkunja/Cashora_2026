import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/base/base_controller.dart';
import '../../../routes/app_routes.dart';

class OrganizationSetupController extends BaseController {
  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  final RxString orgCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    generateOrgCode();
  }

  void generateOrgCode() {
    final random = Random();
    final number = 1000 + random.nextInt(9000); // 4 digit number
    orgCode.value = 'ORG-$number-X';
  }

  void createOrganization() async {
    if (orgNameController.text.isEmpty || 
        fullNameController.text.isEmpty || 
        emailController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    await performAsyncOperation(() async {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      // Get.snackbar('Success', 'Organization Created Successfully');
      Get.offNamed(AppRoutes.ORGANIZATION_SUCCESS); // Navigate to success
    });
  }

  @override
  void onClose() {
    orgNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
