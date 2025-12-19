import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class AdminRequestDetailsController extends GetxController {
  final request = {}.obs;

  @override
  void onInit() {
    super.onInit();
    if(Get.arguments != null) {
      request.value = Get.arguments;
    }
  }

  void approveRequest() {
    // Logic to update backend
    Get.toNamed(AppRoutes.ADMIN_SUCCESS);
  }

  void rejectRequest() {
    // Logic to update backend
    Get.back(); // or show snackbar
  }

  void askClarification() {
    // Logic for clarification
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
