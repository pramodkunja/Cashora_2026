import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/repositories/request_repository.dart';
import '../../../../core/services/network_service.dart';
import '../../../../routes/app_routes.dart';

import '../../../../utils/app_text.dart';

class ProvideClarificationController extends GetxController {
  late final RequestRepository _requestRepository;
  final request = {}.obs;
  final responseController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _requestRepository = RequestRepository(Get.find<NetworkService>());
    if (Get.arguments != null) {
      request.value = Get.arguments;
    }
  }

  @override
  void onClose() {
    responseController.dispose();
    super.onClose();
  }

  Future<void> submitClarification() async {
    if (responseController.text.trim().isEmpty) {
      Get.snackbar(AppText.error, AppText.enterExplanation);
      return;
    }

    try {
      isLoading.value = true;
      final id = request['id']; // Ensure we use numeric ID
      if (id == null) {
        Get.snackbar(AppText.error, AppText.invalidRequestId);
        return;
      }
      
      // Call repository method
      // Call repository method
       await _requestRepository.submitClarification(id is int ? id : int.parse(id.toString()), responseController.text.trim());
      
      // Update local state in-place
      final updatedClarifications = List<Map<String, dynamic>>.from(request['clarifications'] ?? []);
      // We need to add the new response to the last clarification item or create a new one?
      // Usually clarification flow is: Admin Ask -> User Respond. So we update the last item which has the question.
      if (updatedClarifications.isNotEmpty) {
        final lastIndex = updatedClarifications.length - 1;
        final lastItem = Map<String, dynamic>.from(updatedClarifications[lastIndex]);
        lastItem['response'] = responseController.text.trim();
        lastItem['responded_at'] = DateTime.now().toIso8601String();
        updatedClarifications[lastIndex] = lastItem;
      }
      
      final updatedRequest = Map<String, dynamic>.from(request);
      updatedRequest['clarifications'] = updatedClarifications;
      updatedRequest['status'] = 'clarification_responded'; // Update status to reflect change
      request.value = updatedRequest;

      responseController.clear();
      Get.snackbar(AppText.success, AppText.clarificationSubmitted);
    } catch (e) {
      Get.snackbar(AppText.error, AppText.failedToSubmit(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
