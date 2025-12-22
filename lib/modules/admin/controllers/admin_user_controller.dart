import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class AdminUserController extends GetxController {
  // Mock Data
  final rxUsers = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'Sarah Jenkins',
      'role': 'Accountant', // Updated role to match design
      'empId': '#8834',
      'email': 'sarah@company.com',
      'phone': '(555) 123-4567',
      'status': 'Active',
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Michael Chen',
      'role': 'Approver',
      'empId': '#8835',
      'email': 'm.chen@company.com',
      'phone': '+1 (555) 000-0000',
      'status': 'Active',
      'isActive': true,
    },
     {
      'id': '3',
      'name': 'Jessica Wu',
      'role': 'Requestor',
      'empId': '#8836',
      'email': 'jessica.w@company.com',
      'phone': '+1 (555) 000-0000',
      'status': 'Active',
      'isActive': true,
    }
  ].obs;

  final rxSelectedUser = <String, dynamic>{}.obs;
  final rxIsActive = true.obs;

  // Form Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final selectedRole = ''.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void addUser() {
    // Reset form
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    selectedRole.value = '';
    Get.toNamed(AppRoutes.ADMIN_ADD_USER);
  }

  void createUser() {
    // Simulate API call
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    
    Future.delayed(const Duration(seconds: 1), () {
      Get.back(); // Close loader
      // Add to list (mock)
      rxUsers.insert(0, {
        'id': '${rxUsers.length + 1}',
        'name': nameController.text,
        'role': selectedRole.value,
        'email': emailController.text,
        'phone': phoneController.text,
        'isActive': true,
      });
      
      Get.offNamed(AppRoutes.ADMIN_USER_SUCCESS, arguments: {'type': 'create'});
    });
  }

  void updateUser() {
    // Update user logic (Mock)
    Get.toNamed(AppRoutes.ADMIN_USER_SUCCESS, arguments: {'type': 'update'});
  }

  void confirmDeactivate(Map<String, dynamic> user) {
     rxSelectedUser.value = user;
    Get.toNamed(AppRoutes.ADMIN_DEACTIVATE_USER);
  }

  void deactivateUser() {
    // Deactivate logic
    Get.toNamed(AppRoutes.ADMIN_USER_SUCCESS, arguments: {'type': 'deactivate'});
  }

  void editUser(Map<String, dynamic> user) {
    rxSelectedUser.value = user;
    rxIsActive.value = user['isActive'] ?? true;
    
    // Pre-fill controllers logic could go here if using same form for edit
    
    Get.toNamed(AppRoutes.ADMIN_EDIT_USER);
  }
}
