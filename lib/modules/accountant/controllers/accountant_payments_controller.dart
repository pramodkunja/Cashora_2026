import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/accountant_repository.dart';
import '../../../../data/repositories/payment_repository.dart'; // Added import
import '../../../../core/services/network_service.dart';
import '../../../../data/models/payment_response_model.dart';

class AccountantPaymentsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late final AccountantRepository _repository;

  final RxList<Payment> pendingPayments = <Payment>[].obs;
  // keeping completed as user view still uses it potentially or we can fetch it?
  // The user view (CompletedPaymentsTab) was updated to use `completedPayments`.
  // The REPO does NOT have `getCompletedExpenses` anymore (user deleted it).
  // I must fix that too. I'll mock it empty or just comment it out to fix compilation.

  final RxList<Map<String, dynamic>> completedPayments =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    // Initialize repo
    _repository = AccountantRepository(Get.find<NetworkService>());

    // Fetch initial data for the first tab
    fetchPendingPayments();
    // fetchCompletedPayments(); // We will fetch this when tab is switched or initially if we want pre-loading
    // Let's pre-load both as it's small data usually, but also add listener for refresh on tap
    fetchCompletedPayments();

    // Add listener to refresh data on tab switch
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        // Tab is animating
      } else {
        // Tab selection confirmed
        if (tabController.index == 0) {
          fetchPendingPayments();
        } else if (tabController.index == 1) {
          fetchCompletedPayments();
        }
      }
    });
  }

  Future<void> fetchPendingPayments() async {
    try {
      isLoading.value = true;
      final response = await _repository.getPendingPayments();
      pendingPayments.value = response.payments;
    } catch (e) {
      print("Error fetching pending: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCompletedPayments() async {
    try {
      // We need PaymentRepository here. It is not injected in this controller yet.
      // But we can find it via Get.find<PaymentRepository>() if registered.
      // It's registered in PaymentFlowController, but let's be safe.
      if (!Get.isRegistered<PaymentRepository>()) {
        // Should be registered by bindings, but let's assume it is available or accessible
        // or we can just instantiate it like AccountantRepository if internal deps allow.
        // However, let's use Get.find.
      }
      final paymentRepo = Get.find<PaymentRepository>();
      final results = await paymentRepo.getCompletedPayments();
      completedPayments.value = results;
    } catch (e) {
      print("Error fetching completed: $e");
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
