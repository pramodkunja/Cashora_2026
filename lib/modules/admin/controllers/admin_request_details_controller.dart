import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../views/widgets/admin_rejection_dialog.dart';

class AdminRequestDetailsController extends GetxController {
  final request = {}.obs;
  final clarificationController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null) {
      request.value = Get.arguments;
    }
  }

  @override
  void onClose() {
    clarificationController.dispose();
    super.onClose();
  }

  void approveRequest() {
    // Logic to update backend
    Get.toNamed(AppRoutes.ADMIN_SUCCESS);
  }

  void rejectRequest() {
    Get.bottomSheet(
      AdminRejectionDialog(
        onConfirm: (reason) {
          // Logic to update backend with rejection reason
          Get.back(); // Close bottom sheet
          Get.toNamed(AppRoutes.ADMIN_REJECTION_SUCCESS);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void askClarification() {
    Get.toNamed(AppRoutes.ADMIN_CLARIFICATION);
  }

  void submitClarification() {
    if (clarificationController.text.isNotEmpty) {
      // Logic to send clarification
      Get.toNamed(AppRoutes.ADMIN_CLARIFICATION_SUCCESS);
    } else {
      Get.snackbar('Error', 'Please enter your question or comment');
    }
  }

  void viewAttachment() {
    // For now, show a dialog or open a full screen viewer
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/400x400'), // Replace with actual URL
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
