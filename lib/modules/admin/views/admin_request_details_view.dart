import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added
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
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).iconTheme.color, size: 20.sp),
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
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.successBg, // Light Green
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.successGreen, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  AppText.approvedSC,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.successGreen, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() => Text(
                '₹${controller.request['amount'] ?? '0.00'}',
                style: AppTextStyles.h1.copyWith(fontSize: 40.sp),
              )),
          SizedBox(height: 8.h),
          Obx(() => Text(
                controller.request['title'] ?? 'Office Supplies',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 16.sp),
              )),
          SizedBox(height: 32.h),
          _buildInformationCard(context),
          SizedBox(height: 24.h),
          _buildPaymentStatusCard(context),
          SizedBox(height: 24.h),
          _buildApprovalHistory(context),
        ],
      ),
    );
  }

  // --- REJECTED UI ---
  Widget _buildRejectedUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1), // Light Red
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.block, color: AppColors.error, size: 32.sp),
          ),
          SizedBox(height: 16.h),
          Obx(() => Text(
                '₹${controller.request['amount'] ?? '0.00'}',
                style: AppTextStyles.h1.copyWith(fontSize: 40.sp),
              )),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              AppText.statusRejected.toUpperCase(),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 32.h),
          _buildRejectionReasonCard(context),
          SizedBox(height: 24.h),
          _buildInformationCard(context),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppText.navHistory, style: AppTextStyles.h3.copyWith(fontSize: 18.sp)),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
             padding: EdgeInsets.all(24.w),
             decoration: BoxDecoration(
               color: Theme.of(context).cardColor,
               borderRadius: BorderRadius.circular(24.r),
             ),
             child: Column(
               children: [
                 _buildHistoryItem(
                   context, 
                   title: AppText.submitted, 
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
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            children: [
               CircleAvatar(
                radius: 20.r,
                backgroundColor: _getAvatarColor(controller.request['initials'] ?? 'U'), 
                 child: Text(
                   controller.request['initials'] ?? 'U',
                   style: TextStyle(color: _getAvatarTextColor(controller.request['initials'] ?? 'U'), fontWeight: FontWeight.bold, fontSize: 16.sp),
                 ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.request['user'] ?? 'User',
                          style: AppTextStyles.h3.copyWith(fontSize: 16.sp),
                        )),
                    Text(
                      'Marketing Team • 3 days ago', // Placeholder
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Detail Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      '₹${controller.request['amount'] ?? '0.00'}',
                      style: AppTextStyles.h1.copyWith(fontSize: 36.sp),
                    )),
                SizedBox(height: 8.h),
                Obx(() => Text(
                      controller.request['title'] ?? 'Title',
                      style: AppTextStyles.h3.copyWith(fontSize: 18.sp),
                    )),
                SizedBox(height: 24.h),
                _buildInfoRow(Icons.business_center_rounded, AppText.businessMeal),
                SizedBox(height: 16.h),
                _buildInfoRow(Icons.hourglass_empty_rounded, AppText.pendingApproval),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Description Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.description, style: AppTextStyles.h3.copyWith(fontSize: 16.sp)),
                SizedBox(height: 12.h),
                Text(
                  'Lunch meeting with the design team from Acme Inc. to discuss the upcoming Q3 campaign.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Attachment Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppText.attachedBill, style: AppTextStyles.h3.copyWith(fontSize: 16.sp)),
                SizedBox(height: 16.h),
                
                // Dynamic Attachment Logic
                Builder(builder: (context) {
                  final req = controller.request;
                  List<dynamic> files = [];
                  
                  // Normalize input
                  if (req['attachments'] is List) {
                    files = req['attachments'];
                  } else if (req['receipt_url'] != null && req['receipt_url'].toString().isNotEmpty) {
                    files = [req['receipt_url']]; // Treat as single item list
                  } else if (req['file'] != null) {
                    files = [req['file']];
                  }

                  if (files.isEmpty) {
                    return Text("No attachments found.", style: TextStyle(color: AppColors.textSlate, fontSize: 13.sp));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: files.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final file = files[index];
                      String name = "Attachment ${index + 1}";
                      String url = "";

                      if (file is String) {
                        url = file;
                        name = file.split('/').last.split('?').first; 
                      } else if (file is Map) {
                        url = file['url'] ?? file['file'] ?? file['path'] ?? '';
                        name = file['name'] ?? url.split('/').last;
                      }

                      if (url.isEmpty) return const SizedBox.shrink();

                      return GestureDetector(
                        onTap: () => controller.viewAttachment(url),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(Icons.description, color: AppColors.primaryBlue, size: 20.sp),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    Text("Tap to view", style: TextStyle(color: AppColors.primaryBlue, fontSize: 10.sp)),
                                  ],
                                ),
                              ),
                              Icon(Icons.open_in_new, color: AppColors.textSlate, size: 18.sp),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          
          // Action Buttons
          SecondaryButton(
            text: AppText.askClarification,
            onPressed: controller.askClarification,
            backgroundColor: Colors.transparent,
            textColor: AppColors.primaryBlue,
            border: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
            width: double.infinity,
          ),
          SizedBox(height: 16.h),
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
              SizedBox(width: 16.w),
              Expanded(
                child: PrimaryButton(
                  text: AppText.approve,
                  onPressed: controller.approveRequest,
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  // --- COMMON WIDGETS ---

  Widget _buildInformationCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.information, style: AppTextStyles.h3.copyWith(fontSize: 16.sp)),
          SizedBox(height: 24.h),
          _buildLabelValue("Request ID", "#REQ-2023-8492"),
          SizedBox(height: 16.h),
          Row(
            children: [
              Text("Requestor", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
              SizedBox(width: 8.w),
              Flexible( // Added Flexible to prevent overflow
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Ensure row shrinks
                  children: [
                    CircleAvatar(
                      radius: 12.r,
                      backgroundColor: const Color(0xFFE0F2FE),
                      child: Text("JD", style: TextStyle(fontSize: 10.sp, color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(width: 8.w),
                    Flexible( // Text also needs to be flexible
                       child: Text("Jane Doe", style: AppTextStyles.h3.copyWith(fontSize: 14.sp), overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          _buildLabelValue("Department", "Marketing"),
          SizedBox(height: 16.h),
          _buildLabelValue("Submission Date", "Oct 28, 2023"),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Expanded left side
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.payments_outlined, color: AppColors.warning, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded( // Expanded text parsing
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Status", style: AppTextStyles.h3.copyWith(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                      Text("Pending reimbursement", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13.sp), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text("Pending", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalHistory(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppText.approvalTimeline.toUpperCase(), style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          SizedBox(height: 24.h),
           _buildHistoryItem(
             context,
             title: AppText.requestSubmitted,
             date: "Oct 28, 09:41 AM",
             user: "Eleanor Vance",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: AppColors.primaryBlue,
           ),
           _buildHistoryItem(
             context,
             title: AppText.managerApproval,
             date: "Oct 28, 02:15 PM",
             user: "Sarah Connor",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: AppColors.primaryBlue,
           ),
           _buildHistoryItem(
             context,
             title: AppText.finalApproval,
             date: "Oct 29, 10:05 AM",
             user: "Finance Department",
             icon: Icons.check_rounded,
             iconColor: Colors.white,
             iconBg: AppColors.successGreen,
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
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: iconBg ?? iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconBg != null ? iconColor : iconColor, size: 14.sp),
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: Theme.of(context).dividerColor,
              ),
          ],
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.h3.copyWith(fontSize: 15.sp)),
              SizedBox(height: 2.h),
              Text(date, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13.sp)),
              if (user != null)
                 Text(user, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
              if (description != null)
                 Padding(
                   padding: EdgeInsets.only(top: 4.h),
                   child: Text(description, style: AppTextStyles.bodyMedium.copyWith(color: descriptionColor ?? AppColors.textSlate, fontSize: 13.sp)),
                 ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRejectionReasonCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05), // Light Red
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.comment_rounded, color: AppColors.error, size: 16.sp),
              ),
              SizedBox(width: 12.w),
              Text(AppText.reasonForRejection.toUpperCase(), style: AppTextStyles.h3.copyWith(fontSize: 14.sp, color: AppColors.error.withOpacity(0.8))),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '"The receipt image provided is blurry, and the date of transaction is not visible. Please attach a clear photo of the receipt and resubmit."',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, height: 1.5, fontWeight: FontWeight.w500),
          ),
           SizedBox(height: 12.h),
           Text(
             "${AppText.noteFromApprover} • Oct 28, 2023",
             style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontSize: 12.sp),
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
        Text(value, style: AppTextStyles.h3.copyWith(fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 20.sp),
        ),
        SizedBox(width: 12.w),
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
