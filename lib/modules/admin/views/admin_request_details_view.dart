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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).iconTheme.color, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(AppText.requestDetails, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: Obx(() {
          final status = controller.request['status'] ?? 'Pending';
          if (status == 'Approved') {
            return _buildApprovedUI(context);
          } else if (status == 'Rejected') {
            return _buildRejectedUI(context);
          } else {
            return _buildPendingUI(context);
          }
        }),
      ),
    );
  }

  // --- APPROVED UI ---
  Widget _buildApprovedUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.successBg, // Light Green
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: AppColors.successGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  AppText.approvedSC,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.successGreen, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                '₹${controller.request['amount'] ?? '0.00'}',
                style: AppTextStyles.h1.copyWith(fontSize: 40),
              )),
          const SizedBox(height: 8),
          Obx(() => Text(
                controller.request['title'] ?? 'Office Supplies',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 16),
              )),
          const SizedBox(height: 32),
          _buildInformationCard(context),
          const SizedBox(height: 24),
          _buildPaymentStatusCard(context),
          const SizedBox(height: 24),
          _buildApprovalHistory(context),
        ],
      ),
    );
  }

  // --- REJECTED UI ---
  Widget _buildRejectedUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1), // Light Red
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.block, color: AppColors.error, size: 32),
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
                '₹${controller.request['amount'] ?? '0.00'}',
                style: AppTextStyles.h1.copyWith(fontSize: 40),
              )),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              AppText.statusRejected.toUpperCase(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          _buildRejectionReasonCard(context),
          const SizedBox(height: 24),
          _buildInformationCard(context),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("History", style: AppTextStyles.h3.copyWith(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: Theme.of(context).cardColor,
               borderRadius: BorderRadius.circular(24),
             ),
             child: Column(
               children: [
                 _buildHistoryItem(
                   context, 
                   title: "Submitted", 
                   date: "Oct 27, 2023 • 09:15 AM", 
                   icon: Icons.send_rounded, 
                   iconColor: AppColors.primaryBlue,
                   isLast: false,
                 ),
                 _buildHistoryItem(
                   context, 
                   title: "Rejected", 
                   date: "Oct 28, 2023 • 10:42 AM", 
                   description: "By Sarah Connor (Manager)", 
                   descriptionColor: const Color(0xFFEF4444),
                   icon: Icons.cancel, 
                   iconColor: const Color(0xFFEF4444),
                   isLast: true,
                 ),
               ],
             ),
          ),
        ],
      ),
    );
  }

  // --- PENDING UI (Existing) ---
  Widget _buildPendingUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            children: [
               CircleAvatar(
                radius: 20,
                backgroundColor: _getAvatarColor(controller.request['initials'] ?? 'U'), 
                 child: Text(
                   controller.request['initials'] ?? 'U',
                   style: TextStyle(color: _getAvatarTextColor(controller.request['initials'] ?? 'U'), fontWeight: FontWeight.bold),
                 ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
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
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Detail Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                      '₹${controller.request['amount'] ?? '0.00'}',
                      style: AppTextStyles.h1.copyWith(fontSize: 36),
                    )),
                const SizedBox(height: 8),
                Obx(() => Text(
                      controller.request['title'] ?? 'Title',
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                    )),
                const SizedBox(height: 24),
                _buildInfoRow(Icons.business_center_rounded, AppText.businessMeal),
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
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.description, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                const SizedBox(height: 12),
                Text(
                  'Lunch meeting with the design team from Acme Inc. to discuss the upcoming Q3 campaign.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Attachment Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Theme.of(context).dividerColor, width: 1),
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
                            color: Theme.of(context).cardColor.withOpacity(0.9), // Glassy feel
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
          const SizedBox(height: 24),
          
          // Action Buttons
          SecondaryButton(
            text: AppText.askClarification,
            onPressed: controller.askClarification,
            backgroundColor: Colors.transparent,
            textColor: AppColors.primaryBlue,
            border: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            width: double.infinity,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: AppText.reject,
                  onPressed: controller.rejectRequest,
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.2),
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // --- COMMON WIDGETS ---

  Widget _buildInformationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Information", style: AppTextStyles.h3.copyWith(fontSize: 16)),
          const SizedBox(height: 24),
          _buildLabelValue("Request ID", "#REQ-2023-8492"),
          const SizedBox(height: 16),
          Row(
            children: [
              Text("Requestor", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
              const SizedBox(width: 8),
              Flexible( // Added Flexible to prevent overflow
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Ensure row shrinks
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFFE0F2FE),
                      child: Text("JD", style: TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Flexible( // Text also needs to be flexible
                       child: Text("Jane Doe", style: AppTextStyles.h3.copyWith(fontSize: 14), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildLabelValue("Department", "Marketing"),
          const SizedBox(height: 16),
          _buildLabelValue("Submission Date", "Oct 28, 2023"),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Expanded left side
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.payments_outlined, color: AppColors.warning, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded( // Expanded text parsing
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Status", style: AppTextStyles.h3.copyWith(fontSize: 16), overflow: TextOverflow.ellipsis),
                      Text("Pending reimbursement", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("Pending", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalHistory(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("APPROVAL HISTORY", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 24),
           _buildHistoryItem(
             context,
             title: "Request Submitted",
             date: "Oct 28, 09:41 AM",
             user: "Eleanor Vance",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: AppColors.primaryBlue,
           ),
           _buildHistoryItem(
             context,
             title: "Manager Approval",
             date: "Oct 28, 02:15 PM",
             user: "Sarah Connor",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: AppColors.primaryBlue,
           ),
           _buildHistoryItem(
             context,
             title: "Final Approval",
             date: "Oct 29, 10:05 AM",
             user: "Finance Department",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: const Color(0xFF10B981),
             isLast: true,
           ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, {
    required String title,
    required String date,
    String? user,
    String? description,
    Color? descriptionColor,
    required IconData icon,
    required Color iconColor,
    Color? iconBg,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: iconBg ?? iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconBg != null ? iconColor : iconColor, size: 14),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Theme.of(context).dividerColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15)),
              const SizedBox(height: 2),
              Text(date, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13)),
              if (user != null)
                 Text(user, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
              if (description != null)
                 Padding(
                   padding: const EdgeInsets.only(top: 4.0),
                   child: Text(description, style: AppTextStyles.bodyMedium.copyWith(color: descriptionColor ?? AppColors.textSlate, fontSize: 13)),
                 ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionReasonCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05), // Light Red
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.comment_rounded, color: AppColors.error, size: 16),
              ),
              const SizedBox(width: 12),
              Text("REASON FOR REJECTION", style: AppTextStyles.h3.copyWith(fontSize: 14, color: AppColors.error.withOpacity(0.8))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"The receipt image provided is blurry, and the date of transaction is not visible. Please attach a clear photo of the receipt and resubmit."',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, height: 1.5, fontWeight: FontWeight.w500),
          ),
           const SizedBox(height: 12),
           Text(
             "Note from Approver • Oct 28, 2023",
             style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontSize: 12),
           ),
        ],
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
        Text(value, style: AppTextStyles.h3.copyWith(fontSize: 14)),
      ],
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
  
  Color _getAvatarColor(String initials) {
     if (initials.isEmpty) return const Color(0xFFDBEAFE);
     final int hash = initials.codeUnits.fold(0, (p, c) => p + c);
    // Simple mock random color logic
    if (hash % 3 == 0) return const Color(0xFFDBEAFE); // Blue
    if (hash % 3 == 1) return const Color(0xFFF3E8FF); // Purple
    return const Color(0xFFFEF3C7); // Amber
  }
  
  Color _getAvatarTextColor(String initials) {
     if (initials.isEmpty) return const Color(0xFF1D4ED8);
    final int hash = initials.codeUnits.fold(0, (p, c) => p + c);
    if (hash % 3 == 0) return const Color(0xFF1D4ED8); // Blue
    if (hash % 3 == 1) return const Color(0xFF7E22CE); // Purple
     return const Color(0xFFB45309); // Amber
  }
}
