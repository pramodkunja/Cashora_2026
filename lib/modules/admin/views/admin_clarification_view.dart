import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/admin_request_details_controller.dart';
import 'widgets/admin_app_bar.dart';

class AdminClarificationView extends GetView<AdminRequestDetailsController> {
  const AdminClarificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Controller is already put in previous screen, so we can access it.
    // However, if we need a text controller specifically for this view, we can add it to the controller or use a local one.
    // For now, let's assume the controller handles it or we use a local one and pass data back.
    // Actually, best practice with GetX is to put logic in controller.
    // I'll update controller to have clarification text controller.
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const AdminAppBar(title: AppText.askClarificationTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.requestDetails, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            // Request Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Text(
                        controller.request['user'] ?? 'User',
                        style: AppTextStyles.h3.copyWith(fontSize: 16),
                      )),
                      const SizedBox(height: 4),
                       Obx(() => Text(
                        controller.request['title'] ?? 'Title',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                      )),
                    ],
                  ),
                  const Spacer(),
                   // Placeholder Ticket Image
                   Container(
                     height: 80,
                     width: 100,
                     decoration: BoxDecoration(
                       color: const Color(0xFFFDE68A), // Amber 200
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          // Using a placeholder that looks like a receipt
                          image: NetworkImage('https://img.freepik.com/free-psd/receipt-mockup-floating_1332-9024.jpg?w=200'), 
                          fit: BoxFit.cover,
                        ),
                     ),
                   ),
                ],
              ),
            ),
             // Price Badge separately or inside? Design shows price inside light blue pill.
             const SizedBox(height: 12),
             Obx(() => Container(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               decoration: BoxDecoration(
                 color: Theme.of(context).primaryColor.withOpacity(0.1), // Light Blue
                 borderRadius: BorderRadius.circular(20),
               ),
               child: Text(
                 '\$${controller.request['amount'] ?? '0.00'}',
                 style: AppTextStyles.h3.copyWith(fontSize: 14, color: AppColors.primaryBlue),
               ),
             )),

            const SizedBox(height: 32),
            Text(AppText.yourQuestions, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: TextField(
                controller: controller.clarificationController,
                maxLines: 6,
                decoration: const InputDecoration.collapsed(
                  hintText: AppText.clarificationHint,
                  hintStyle: TextStyle(color: AppColors.textSlate),
                ),
                style: AppTextStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: 100), // Spacer for bottom
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: PrimaryButton(
            text: AppText.sendBackForClarification,
            onPressed: () => controller.submitClarification(),
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}
