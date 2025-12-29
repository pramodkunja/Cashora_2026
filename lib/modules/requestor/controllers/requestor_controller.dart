import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../../core/services/auth_service.dart';

class RequestorController extends GetxController {
  
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  final recentRequests = <Map<String, dynamic>>[
    {
      'title': 'Team Lunch',
      'date': '12 Dec 2023',
      'amount': 45.00,
      'status': 'Pending',
      'icon': Icons.restaurant,
      'color': AppColors.warning.withOpacity(0.1),
      'iconColor': AppColors.warning,
    },
    {
      'title': 'Flight to Conference',
      'date': '10 Dec 2023',
      'amount': 289.99,
      'status': 'Approved',
      'icon': Icons.flight,
      'color': AppColors.primary.withOpacity(0.1),
      'iconColor': AppColors.primary,
    },
     {
      'title': 'Taxi from Airport',
      'date': '08 Dec 2023',
      'amount': 25.50,
      'status': 'Rejected',
      'icon': Icons.directions_car,
      'color': AppColors.error.withOpacity(0.1),
      'iconColor': AppColors.error,
    },
  ].obs;

  final userName = ''.obs;

  final showWelcome = true.obs;

  String get shortName {
    final name = userName.value;
    if (name.isEmpty || name == 'User') return 'User';
    if (name.contains(' ')) {
      return name.split(' ').first;
    }
    return name;
  }

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    if (authService.currentUser.value != null) {
      userName.value = authService.currentUser.value!.name;
    } else {
      userName.value = 'User';
    }

    // Auto-hide welcome message after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      showWelcome.value = false;
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
