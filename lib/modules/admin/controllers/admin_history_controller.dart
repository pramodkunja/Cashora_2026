import 'package:get/get.dart';
import '../../../../utils/app_text.dart';
import '../../../../routes/app_routes.dart';

class AdminHistoryController extends GetxController {
  final historyRequests = <Map<String, dynamic>>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxMap<String, dynamic> _selectedRequest = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistoryData();
  }

  Map<String, dynamic> get selectedRequest => _selectedRequest;

  List<Map<String, dynamic>> get filteredRequests {
    if (selectedFilter.value == 'All') {
      return historyRequests;
    }
    return historyRequests.where((item) {
      if (selectedFilter.value == 'Approved') return item['status'] == AppText.statusApproved;
      if (selectedFilter.value == 'Rejected') return item['status'] == AppText.statusRejected;
      if (selectedFilter.value == 'Clarified') return item['status'] == AppText.clarification;
      return true;
    }).toList();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void viewDetails(Map<String, dynamic> item) {
    _selectedRequest.value = item;
    if (item['status'] == AppText.clarification) {
      Get.toNamed(AppRoutes.ADMIN_CLARIFICATION_STATUS, arguments: item);
    } else {
      Get.toNamed(AppRoutes.ADMIN_REQUEST_DETAILS, arguments: item);
    }
  }

  void _loadHistoryData() {
    historyRequests.value = [
      {
        'id': 'REQ-2023-892',
        'title': 'Marketing Supplies',
        'user': 'Sarah Jennings',
        'initials': 'SJ',
        'date': 'Oct 24, 2023',
        'amount': '125.00',
        'status': AppText.statusApproved,
        'actionDate': 'Oct 24, 2023',
      },
      {
        'id': 'REQ-2023-891',
        'title': 'Client Dinner',
        'user': 'Mike Kowalski',
        'initials': 'MK',
        'date': 'Oct 23, 2023',
        'amount': '450.00',
        'status': AppText.statusRejected,
        'actionDate': 'Oct 23, 2023',
      },
      {
        'id': 'REQ-2023-889',
        'title': 'Software License',
        'user': 'Amy Lee',
        'initials': 'AL',
        'date': 'Oct 20, 2023',
        'amount': '89.99',
        'status': AppText.clarification,
        'actionDate': 'Oct 20, 2023',
      },
      {
        'id': 'REQ-2023-885',
        'title': 'Travel Expense',
        'user': 'David Jones',
        'initials': 'DJ',
        'date': 'Oct 18, 2023',
        'amount': '320.50',
        'status': AppText.statusApproved,
        'actionDate': 'Oct 18, 2023',
      },
    ];
  }
}
