import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_text.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../core/services/network_service.dart';

class AdminApprovalsController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AdminRepository _adminRepository;
  
  final pendingRequests = <Map<String, dynamic>>[].obs;
  final approvedRequests = <Map<String, dynamic>>[].obs;
  final unpaidRequests = <Map<String, dynamic>>[].obs;
  final clarificationRequests = <Map<String, dynamic>>[].obs;
  
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _adminRepository = AdminRepository(Get.find<NetworkService>());
    // fetchAllRequests(); // Moved to onReady
  }
  
  @override
  void onReady() {
    super.onReady();
    fetchAllRequests();
  }

  Future<void> fetchAllRequests() async {
    try {
      isLoading.value = true;
      
      final results = await Future.wait([
        _adminRepository.getOrgExpenses(status: 'pending'),
        _adminRepository.getOrgExpenses(status: 'approved'),
        _adminRepository.getOrgExpenses(paymentStatus: 'pending'),
        _adminRepository.getOrgExpenses(status: 'clarification_required'), 
        _adminRepository.getOrgExpenses(status: 'clarification_responded')
      ]);

      pendingRequests.assignAll(results[0]);
      approvedRequests.assignAll(results[1]);
      unpaidRequests.assignAll(results[2]);
      
      // Combine clarification required and responded
      final combinedClarification = <Map<String, dynamic>>[];
      combinedClarification.addAll(results[3]);
      combinedClarification.addAll(results[4]);
      // Sort by date descending if possible, for now just list
      clarificationRequests.assignAll(combinedClarification);
      
      print("Debugging Data Fetch:");
      print("Pending: ${results[0].length}");
      print("Clarification Response Count: ${results[4].length}");
      if (results[4].isNotEmpty) {
         print("Sample Clarification Response: ${results[4].first}");
      }

    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToDetails(Map<String, dynamic> request) {
    // If status implies clarification, go to clarification view
    String status = request['status'] ?? '';
    if (status == 'clarification_required' || status == 'clarification_responded') {
      Get.toNamed(AppRoutes.ADMIN_CLARIFICATION_STATUS, arguments: request);
    } else {
      Get.toNamed(AppRoutes.ADMIN_REQUEST_DETAILS, arguments: request);
    }
  }
  
  String getInitials(String name) {
    if (name.isEmpty) return '??';
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
