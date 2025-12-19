import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_text.dart';

class AdminApprovalsController extends GetxController with GetSingleTickerProviderStateMixin {
  final requests = <Map<String, dynamic>>[].obs;
  final selectedIndex = 1.obs;
  
  // Tabs
  late final tabController;
  final tabs = [AppText.tabPending, AppText.tabApproved, AppText.tabRejected];

  @override
  void onInit() {
    super.onInit();
    // Use dynamic late initialization for TabController since we need TickerProvider
    // but in GetxController usually onInit is fine if mixed in.
    // However, GetSingleTickerProviderStateMixin expects a widget context often or properly initialized mixin.
    // For simplicity with GetX simple state management for tabs might be easier, 
    // but user wants standard UI. Let's mock data.
    _loadMockData();
  }
  
  void setupTabController(ticker) {
    // This method will be called from View
  }

  void _loadMockData() {
    requests.value = [
      {
        'id': 'REQ-001',
        'title': 'Office Supplies',
        'user': 'Eleanor Vance',
        'date': 'Oct 28, 2023',
        'amount': '55.00',
        'status': AppText.statusPending,
      },
      {
        'id': 'REQ-002',
        'title': 'Team Lunch',
        'user': 'Liam Chen',
        'date': 'Oct 27, 2023',
        'amount': '120.75',
        'status': AppText.statusPending,
      },
      {
        'id': 'REQ-003',
        'title': 'Software Subscription',
        'user': 'Ava Rodriguez',
        'date': 'Oct 26, 2023',
        'amount': '99.99',
        'status': AppText.statusApproved,
      },
      {
        'id': 'REQ-004',
        'title': 'Client Meeting Expenses',
        'user': 'Noah Kim',
        'date': 'Oct 25, 2023',
        'amount': '78.50',
        'status': AppText.statusApproved,
      },
      {
        'id': 'REQ-005',
        'title': 'Travel Reimbursement',
        'user': 'Isabella Garcia',
        'date': 'Oct 24, 2023',
        'amount': '250.00',
        'status': AppText.statusRejected,
      },
    ];
  }

  List<Map<String, dynamic>> get pendingRequests => 
      requests.where((r) => r['status'] == AppText.statusPending).toList();
      
  List<Map<String, dynamic>> get approvedRequests => 
      requests.where((r) => r['status'] == AppText.statusApproved).toList();
      
  List<Map<String, dynamic>> get rejectedRequests => 
      requests.where((r) => r['status'] == AppText.statusRejected).toList();

  void navigateToDetails(Map<String, dynamic> request) {
    Get.toNamed(AppRoutes.ADMIN_REQUEST_DETAILS, arguments: request);
  }

  void changeTabIndex(int index) {
      selectedIndex.value = index;
      if (index == 0) {
        Get.offNamed(AppRoutes.ADMIN_DASHBOARD);
      }
      // Handle other navs
  }
}
