import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../../../utils/widgets/buttons/secondary_button.dart';
import '../controllers/admin_request_details_controller.dart';

class AdminRequestDetailsView extends GetView<AdminRequestDetailsController> {
  const AdminRequestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(AppText.requestDetails, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey, // Placeholder
                    // backgroundImage: NetworkImage(userImage),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.request['user'] ?? 'User',
                        style: AppTextStyles.h3.copyWith(fontSize: 16),
                      )),
                      Text(
                        'Marketing Team • 3 days ago', // Placeholder
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Detail Card - Keeping existing shadows
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      '\$${controller.request['amount'] ?? '0.00'}',
                      style: AppTextStyles.h1.copyWith(fontSize: 36),
                    )),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      controller.request['title'] ?? 'Title',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    )),
                    const SizedBox(height: 24),

                    _buildInfoRow(Icons.business_center_rounded, AppText.businessMeal), // Dynamic in real app
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.hourglass_empty_rounded, AppText.pendingApproval),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Description Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.description, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    const SizedBox(height: 12),
                    Text(
                      'Lunch meeting with the design team from Acme Inc. to discuss the upcoming Q3 campaign. The meeting was held at The Corner Bistro.', // Placeholder
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Attachment Card - Redesigned
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppText.attachedBill, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: controller.viewAttachment,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderLight, width: 1),
                          image: const DecorationImage(
                            image: NetworkImage('https://via.placeholder.com/400x200'), // Placeholder
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2), // Darker overlay for better text contrast
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Larger touch target
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9), // Glassy white feel
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.visibility_rounded, size: 18, color: AppColors.textDark),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppText.tapToView,
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48), // Spacing before buttons
              
              // Action Buttons - Moved here to scroll with content
              SecondaryButton(
                text: AppText.askClarification,
                onPressed: controller.askClarification,
                backgroundColor: Colors.transparent,
                textColor: AppColors.primaryBlue,
                border: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
                width: double.infinity, // Full width
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: AppText.reject,
                      onPressed: controller.rejectRequest,
                      backgroundColor: const Color(0xFFE2E8F0), // Grey
                      textColor: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: AppText.approve,
                      onPressed: controller.approveRequest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Text(text, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
