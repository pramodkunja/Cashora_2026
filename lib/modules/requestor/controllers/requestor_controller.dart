import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/services/auth_service.dart';

class RequestorController extends GetxController {
  
  final selectedIndex = 0.obs;

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  final recentRequests = <Map<String, dynamic>>[
    {
      'title': 'Team Lunch',
      'date': '12 Dec 2023',
      'amount': 45.00,
      'status': 'Pending',
      'icon': Icons.restaurant,
      'color': Colors.orange[100],
      'iconColor': Colors.orange,
    },
    {
      'title': 'Flight to Conference',
      'date': '10 Dec 2023',
      'amount': 289.99,
      'status': 'Approved',
      'icon': Icons.flight,
      'color': Colors.blue[100],
      'iconColor': Colors.blue,
    },
     {
      'title': 'Taxi from Airport',
      'date': '08 Dec 2023',
      'amount': 25.50,
      'status': 'Rejected',
      'icon': Icons.directions_car,
      'color': Colors.red[100],
      'iconColor': Colors.red,
    },
  ].obs;

  final userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final authService = Get.find<AuthService>();
    if (authService.currentUser.value != null) {
      userName.value = authService.currentUser.value!.name;
    } else {
      userName.value = 'User';
    }
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
