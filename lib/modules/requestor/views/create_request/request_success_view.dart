import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/create_request_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';

class RequestSuccessView extends GetView<CreateRequestController> {
  const RequestSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
           IconButton(
             icon: const Icon(Icons.close, color: AppColors.textSlate),
             onPressed: () => Get.offAllNamed(AppRoutes.REQUESTOR),
           ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
          child: Obx(() {
            if (controller.category.value == 'Deemed') {
              return _buildDeemedSuccessUI();
            } else {
              return _buildStandardSuccessUI(); 
            }
          }),
        ),
      ),
    );
  }

  Widget _buildDeemedSuccessUI() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFE4F8F0), 
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 40, color: AppColors.successGreen),
        ),
        const SizedBox(height: 24),
        Text(
          AppText.requestApproved,
          textAlign: TextAlign.center,
          style: AppTextStyles.h1.copyWith(fontSize: 24, height: 1.2),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppText.fundsAdded,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
          ),
        ),
        const SizedBox(height: 32),
        
        Stack(
          children: [
             Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Text(AppText.totalAmount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 1.0)),
                  const SizedBox(height: 8),
                  Text(
                    '₹${controller.amount.value.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 24),
                  
                  _buildRowItem(
                    icon: controller.selectedExpenseCategory.value?['icon'] ?? Icons.inventory_2_outlined,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0EA5E9),
                    label: AppText.category,
                    value: controller.selectedExpenseCategory.value?['name'] ?? 'General',
                  ),
                  const SizedBox(height: 20),
                   _buildRowItem(
                    icon: Icons.tag,
                    iconBg: const Color(0xFFF1F5F9),
                     iconColor: const Color(0xFF64748B),
                    label: AppText.requestId,
                    value: '#REQ-${DateTime.now().year}-89',
                  ),
                   const SizedBox(height: 24),
                   
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(AppText.status, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                         decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF86EFAC))),
                         child: Row(
                           children: [
                             const Icon(Icons.check, size: 14, color: Color(0xFF15803D)),
                             const SizedBox(width: 4),
                             Text(AppText.approvedSC, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF15803D))),
                           ],
                         ),
                       )
                     ],
                   ),
                    const SizedBox(height: 16),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text(AppText.paymentStatus, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                         decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFCBD5E1))),
                         child: Row(
                           children: [
                             const Icon(Icons.hourglass_empty, size: 14, color: Color(0xFF475569)),
                             const SizedBox(width: 4),
                             Text(AppText.pendingSC, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                           ],
                         ),
                       )
                     ],
                   ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: AppText.goToDashboard,
            onPressed: () => Get.offAllNamed(AppRoutes.REQUESTOR),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
             Get.offAllNamed(AppRoutes.REQUESTOR);
          }, 
          child: Text(AppText.viewDetails, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.w600))
        ),
         const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRowItem({required IconData icon, required Color iconBg, required Color iconColor, required String label, required String value}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStandardSuccessUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 60),
        Container(
          width: 120,
          height: 120,
          decoration: const BoxDecoration(
            color: AppColors.infoBg,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_rounded, size: 60, color: AppColors.primaryBlue),
        ),
        const SizedBox(height: 32),
        Text(
          AppText.requestSubmitted,
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: 16),
        Text(
          AppText.requestSubmittedDesc,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
        ),
        const SizedBox(height: 60),
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: AppText.goToDashboard,
            onPressed: () {
              Get.offAllNamed(AppRoutes.REQUESTOR); 
            },
          ),
        ),
      ],
    );
  }
}
