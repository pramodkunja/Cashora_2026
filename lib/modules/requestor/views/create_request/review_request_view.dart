import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/create_request_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';

class ReviewRequestView extends GetView<CreateRequestController> {
  const ReviewRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppText.reviewRequest, style: AppTextStyles.h3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
               Text(AppText.totalRequestedAmount, style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodyMedium.color)),
               const SizedBox(height: 4),
               Obx(() => Text('₹${controller.amount.value.toStringAsFixed(2)}', style: AppTextStyles.h1.copyWith(fontSize: 40))),
               const SizedBox(height: 32),

               Container(
                 padding: const EdgeInsets.all(24),
                 decoration: BoxDecoration(
                   color: Theme.of(context).cardColor,
                   borderRadius: BorderRadius.circular(24),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(AppText.requestDetails, style: AppTextStyles.h3.copyWith(fontSize: 18)),
                     const SizedBox(height: 24),
                     
                     Obx(() => _buildDetailItem(icon: Icons.receipt_long, title: AppText.requestType, value: controller.requestType.value)),
                     const SizedBox(height: 24),
                     Obx(() {
                        final cat = controller.selectedExpenseCategory.value;
                        return _buildDetailItem(
                          icon: cat?['icon'] ?? Icons.category, 
                          title: AppText.category, 
                          value: cat?['name'] ?? AppText.notSelected,
                          iconColorOverride: AppColors.primaryBlue,
                        );
                     }),
                     const SizedBox(height: 24),
                     Obx(() => _buildDetailItem(icon: Icons.label, title: AppText.purpose, value: controller.purpose.value)),
                     const SizedBox(height: 24),
                     Obx(() => _buildDetailItem(icon: Icons.description, title: AppText.description, value: controller.description.value)),
                   ],
                 ),
               ),
               const SizedBox(height: 24),

               // Attachments
               Container(
                 padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                   color: Theme.of(context).cardColor,
                   borderRadius: BorderRadius.circular(24),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                      Text(AppText.attachments, style: AppTextStyles.h3.copyWith(fontSize: 18)),
                      const SizedBox(height: 16),
                      Obx(() => controller.attachedFiles.isNotEmpty 
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.attachedFiles.length,
                            separatorBuilder: (ctx, idx) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              XFile file = controller.attachedFiles[index];
                              return GestureDetector(
                                onTap: () => _showImagePreview(context, file),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor), borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(8)),
                                        child: const Icon(Icons.image, color: AppColors.primaryBlue),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(file.name, overflow: TextOverflow.ellipsis)),
                                      const Icon(Icons.visibility, size: 18, color: AppColors.textLight),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Text(AppText.noAttachments, style: const TextStyle(color: Colors.grey))),
                   ],
                 ),
               ),
               const SizedBox(height: 32),
               SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: AppText.submitRequest,
                  onPressed: () {
                     Get.toNamed(AppRoutes.CREATE_REQUEST_SUCCESS);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, XFile file) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.file(
                File(file.path),
                fit: BoxFit.contain,
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: CircleAvatar(
                 backgroundColor: Colors.black54,
                 child: IconButton(
                   icon: const Icon(Icons.close, color: Colors.white),
                   onPressed: () => Get.back(),
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String title, required String value, Color? iconColorOverride}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(color: Color(0xFFE0F2FE), shape: BoxShape.circle),
          child: Icon(icon, color: iconColorOverride ?? const Color(0xFF0EA5E9), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(title, style: TextStyle(color: AppTextStyles.bodyMedium.color, fontSize: 13)),
               const SizedBox(height: 4),
               Text(value.isEmpty ? '-' : value, style: TextStyle(color: AppTextStyles.h3.color, fontWeight: FontWeight.w600, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
