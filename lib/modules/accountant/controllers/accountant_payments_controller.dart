import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/accountant_repository.dart';
import '../../../../core/services/network_service.dart';

class AccountantPaymentsController extends GetxController with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late final AccountantRepository _repository;
  
  final RxList<Map<String, dynamic>> pendingPayments = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    
    // Initialize repo
    _repository = AccountantRepository(Get.find<NetworkService>());
    
    // Fetch data
    fetchPendingPayments();
  }
  
  Future<void> fetchPendingPayments() async {
    try {
      isLoading.value = true;
      final results = await _repository.getPendingPayments();
      // Sort by date desc (if needed, but API usually handles it)
      // results.sort((a, b) => ...);
      pendingPayments.value = results;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch pending payments');
    } finally {
      isLoading.value = false; 
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onBottomNavTap(int index) {
      switch (index) {
      case 0:
        Get.offNamed(AppRoutes.ACCOUNTANT_DASHBOARD);
        break;
      case 1:
        // Current
        break;
      case 2:
        // Get.toNamed(AppRoutes.ACCOUNTANT_REPORTS);
        break;
      case 3:
        Get.offNamed(AppRoutes.ACCOUNTANT_PROFILE);
        break;
    }
  }
}

