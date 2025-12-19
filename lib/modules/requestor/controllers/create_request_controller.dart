import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class CreateRequestController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Observable state
  final requestType = 'Post-approved'.obs; 
  final amount = 0.0.obs;
  final category = 'Deemed'.obs; // Auto-calculated status (Deemed/Approval Required)
  final purpose = ''.obs;
  final description = ''.obs;
  final attachedFiles = <XFile>[].obs;

  // New Expense Category Logic
  final selectedExpenseCategory = Rxn<Map<String, dynamic>>();
  final List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Travel', 'icon': Icons.flight},
    {'name': 'Food & Dining', 'icon': Icons.restaurant},
    {'name': 'Office Supplies', 'icon': Icons.shopping_bag},
    {'name': 'Transport', 'icon': Icons.directions_car},
    {'name': 'Accommodation', 'icon': Icons.hotel},
    {'name': 'Entertainment', 'icon': Icons.movie},
    {'name': 'Other', 'icon': Icons.category},
  ];

  // Text Controllers
  final amountController = TextEditingController();
  final purposeController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(() {
      final val = double.tryParse(amountController.text.replaceAll(',', '')) ?? 0.0;
      amount.value = val;
      if (val > 1000) {
        category.value = 'Approval Required';
      } else {
        category.value = 'Deemed';
      }
    });

    purposeController.addListener(() {
      purpose.value = purposeController.text;
    });

     descriptionController.addListener(() {
      description.value = descriptionController.text;
    });
  }

  Future<void> pickImage(ImageSource source) async {
    print("Attempting to pick image from $source");
    PermissionStatus status;
    
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      // Android 13+ logic
      if (await Permission.photos.status.isGranted || await Permission.mediaLibrary.status.isGranted) {
           status = PermissionStatus.granted;
      } else if (await Permission.storage.isGranted) {
           status = PermissionStatus.granted;
      } else {
           Map<Permission, PermissionStatus> statuses = await [
              Permission.storage,
              Permission.photos,
              Permission.mediaLibrary
           ].request();
           
           if (statuses.values.any((s) => s.isGranted)) {
             status = PermissionStatus.granted;
           } else {
             status = PermissionStatus.denied;
           }
      }
    }

    if (status.isGranted || status.isLimited) {
      try {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          attachedFiles.add(image);
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to pick image: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red[100]);
      }
    } else if (status.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: const Text('Permission Required'),
          content: const Text('Please enable camera/gallery permissions in settings to use this feature.'),
          actions: [
            TextButton(child: const Text('Cancel'), onPressed: () => Get.back()),
            TextButton(child: const Text('Settings'), onPressed: () {
               Get.back();
               openAppSettings();
            }),
          ],
        )
      );
    } else {
      Get.snackbar('Permission Denied', 'We need permission to access your camera/gallery.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void removeFile(int index) {
    if (index >= 0 && index < attachedFiles.length) {
      attachedFiles.removeAt(index);
    }
  }

  bool validateRequest() {
    if (selectedExpenseCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
    if (purpose.value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a purpose for the request',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        margin: const EdgeInsets.all(16),
      );
      return false;
    }
    return true;
  }

  void submitRequest() {
    Get.offAllNamed('/create-request/success');
  }
  
  @override
  void onClose() {
    amountController.dispose();
    purposeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
