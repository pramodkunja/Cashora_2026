import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_request_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';

class SelectRequestTypeView extends GetView<CreateRequestController> {
  const SelectRequestTypeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(AppText.selectRequestType, style: AppTextStyles.h3),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textDark),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppText.approvalTime, // TODO: Add to AppText if generic
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 16),
              
              // Pre-approved Option
              Obx(() => _buildOptionCard(
                title: AppText.preApproved,
                subtitle: AppText.preApprovedDesc,
                value: AppText.preApproved,
                groupValue: controller.requestType.value,
                icon: Icons.timelapse,
                onChanged: (val) => controller.requestType.value = val!,
              )),
              
              const SizedBox(height: 16),

              // Post-approved Option
              Obx(() => _buildOptionCard(
                title: AppText.postApproved,
                subtitle: AppText.postApprovedDesc,
                value: AppText.postApproved,
                groupValue: controller.requestType.value,
                icon: Icons.receipt,
                onChanged: (val) => controller.requestType.value = val!,
              )),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: AppText.requestDetails,
                  onPressed: () {
                    Get.toNamed(AppRoutes.CREATE_REQUEST_DETAILS);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required String subtitle,
    required String value,
    required String groupValue,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0F2FE) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFF0EA5E9) : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
           boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF64748B), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: const Color(0xFF0EA5E9),
            ),
          ],
        ),
      ),
    );
  }
}
