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
import '../../../../utils/widgets/buttons/secondary_button.dart';

class RequestDetailsView extends GetView<CreateRequestController> {
  const RequestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(AppText.requestDetails, style: AppTextStyles.h3),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.amount, style: AppTextStyles.h2),
              const SizedBox(height: 12),
              TextField(
                controller: controller.amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyles.amountDisplay.copyWith(color: AppColors.textDark),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 8), 
                    child: Text(
                      '₹',
                      style: AppTextStyles.amountDisplay.copyWith(color: AppColors.textDark),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ),
              const SizedBox(height: 24),

              Text(AppText.requestType, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(controller.category.value, style: const TextStyle(color: Color(0xFF64748B), fontSize: 16)),
                     const IconButton(icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)), onPressed: null),
                  ],
                ),
              )),
              
              const SizedBox(height: 16),
              // Warning Banner
              Obx(() {
                if (controller.category.value == AppText.approvalRequired) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB), // Yellow 50
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFEF3C7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFFDE68A), shape: BoxShape.circle),
                          child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(AppText.approvalRequired, style: const TextStyle(color: Color(0xFF78350F), fontWeight: FontWeight.w700)),
                            Text(AppText.approvalRequiredDesc, style: const TextStyle(color: Color(0xFF92400E), fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 24),

              
              Text(AppText.category, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Map<String, dynamic>>(
                    value: controller.selectedExpenseCategory.value,
                    hint: Text(AppText.selectCategory, style: AppTextStyles.hintText),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSlate),
                    borderRadius: BorderRadius.circular(16),
                    dropdownColor: Colors.white,
                    items: controller.expenseCategories.map((cat) {
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: cat,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.infoBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(cat['icon'], color: AppColors.primaryBlue, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Text(cat['name'], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => controller.selectedExpenseCategory.value = val,
                  ),
                ),
              )),
              const SizedBox(height: 24),

              Text(AppText.purpose, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.purposeController,
                decoration: InputDecoration(
                  hintText: AppText.purposeHint,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              Text(AppText.descriptionOptional, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 8),
              TextField(
                controller: controller.descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: AppText.descriptionPlaceholder,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: AppText.takePhoto,
                      onPressed: () => controller.pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SecondaryButton(
                      text: AppText.uploadBill,
                      onPressed: () => controller.pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.upload_file, color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => controller.attachedFiles.isNotEmpty 
                ? Column(
                    children: controller.attachedFiles.asMap().entries.map((entry) {
                      int idx = entry.key;
                      XFile file = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
                        child: Row(
                          children: [
                            const Icon(Icons.description, color: Color(0xFF64748B), size: 20),
                            const SizedBox(width: 8),
                            Expanded(child: Text(file.name, style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis)),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red, size: 20),
                              onPressed: () => controller.removeFile(idx),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : const SizedBox.shrink()),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: AppText.reviewRequest,
                  onPressed: () {
                    if (controller.validateRequest()) {
                      Get.toNamed(AppRoutes.CREATE_REQUEST_REVIEW);
                    }
                  },
                  icon: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
