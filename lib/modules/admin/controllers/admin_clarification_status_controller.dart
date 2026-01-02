import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_text.dart';
import '../../../../data/repositories/admin_repository.dart';
import '../../../../core/services/network_service.dart';

enum ClarificationState {
  pending,
  responded,
  askingAgain,
}

class AdminClarificationStatusController extends GetxController {
  final Rx<ClarificationState> state = ClarificationState.pending.obs;
  final RxMap<String, dynamic> request = <String, dynamic>{}.obs;
  AdminRepository? _adminRepository;

  AdminRepository get repo => _adminRepository ??= AdminRepository(Get.find<NetworkService>());


  void toggleSimulateResponse() {
    if (state.value == ClarificationState.pending) {
      state.value = ClarificationState.responded;
    } else {
      state.value = ClarificationState.pending;
    }
  }

  final reasonController = TextEditingController(); // For ask again or reject

  @override
  void onInit() {
    super.onInit();
    request.value = Get.arguments ?? {};
    state.value = _determineState(request['status']);
    
    // DEBUG LOG
    print("DEBUG: AdminClarificationStatusController initialized");
    print("DEBUG: Request ID: ${request['id']}");
    print("DEBUG: Request Data: $request");
    
    _adminRepository = AdminRepository(Get.find<NetworkService>());
  }

  ClarificationState _determineState(String? status) {
    if (status == 'clarification_responded') {
      return ClarificationState.responded;
    }
    return ClarificationState.pending;
  }

  
  @override
  void onClose() {
      reasonController.dispose();
      super.onClose();
  }

  void startAskAgain() {
    state.value = ClarificationState.askingAgain;
  }

  Future<void> submitAskAgain() async {
    final String question = reasonController.text.trim();
    if (question.isEmpty) {
        Get.snackbar("Error", "Please provide a reason/question");
        return;
    }
    try {
        final id = request['id'];
        if (id == null) return;
        
        await repo.askClarification(id is int ? id : int.parse(id.toString()), question);
        
        // Success
        Get.snackbar(AppText.success, AppText.sentBackSuccessfully);
        
        // Update local state without navigation
        // 1. Add new question to clarifications list
        final updatedClarifications = List<Map<String, dynamic>>.from(request['clarifications'] ?? []);
        updatedClarifications.add({
            'question': question,
            'response': '', // Empty response initially
            'asked_at': DateTime.now().toIso8601String(),
            'responded_at': '',
        });
        
        // 2. Update request object
        final updatedRequest = Map<String, dynamic>.from(request);
        updatedRequest['clarifications'] = updatedClarifications;
        updatedRequest['status'] = 'clarification_required'; // or whatever pending status is
        request.value = updatedRequest;
        
        // 3. Reset UI state
        state.value = ClarificationState.pending;
        reasonController.clear();
        
    } catch (e) {
        Get.snackbar("Error", "Failed to ask clarification: $e");
    }
  }

  Future<void> approve() async {
    try {
        final id = request['id']; // Use numeric ID for API
        if (id == null) return;
        
        await repo.approveRequest(id); 
        
        Get.back(result: true);
        Get.snackbar(AppText.approvedSuccessTitle, AppText.approvedSuccessDesc);
    } catch (e) {
        Get.snackbar("Error", "Failed to approve: $e");
    }
  }

  Future<void> reject() async {
    // Ideally open a dialog to get reason. For now assuming minimal or using reasonController if exposed
    try {
        final id = request['id']; // Use numeric ID for API
        if (id == null) return;
        
        // Hardcoding 'Rejected by Admin' for now if reason not captured
        await repo.rejectRequest(id, "Rejected by Admin"); 
        
        Get.back(result: true);
        Get.snackbar(AppText.requestRejected, AppText.requestRejectedDesc);
    } catch(e) {
        Get.snackbar("Error", "Failed to reject: $e");
    }
  }
}
