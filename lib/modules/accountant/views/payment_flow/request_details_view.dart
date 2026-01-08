import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Added
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/payment_flow_controller.dart';

class PaymentRequestDetailsView extends GetView<PaymentFlowController> {
  const PaymentRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get request data from arguments or controller
    final Map<String, dynamic> request = Get.arguments['request'] ?? {};
    final requestor = request['requestor'] ?? {};
    final approver = request['approver'] ?? {};

    final String amount = '₹${request['amount']?.toString() ?? '0.00'}';
    final String requestId = request['request_id'] ?? (request['id'] != null ? '#REQ-${request['id']}' : '');
    final String date = _formatDate(request['created_at']);
    final String purpose = request['purpose'] ?? 'N/A';
    final String description = request['description'] ?? 'No Description';
    final String requestorName = "${requestor['first_name'] ?? ''} ${requestor['last_name'] ?? ''}".trim();
    final String requestorRole = requestor['role'] ?? 'Requestor';
    
    // Receipt/Bill
    final String? receiptUrl = request['receipt_url'];
    final String? qrUrl = request['qr_url']; // Assuming backend key

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        // ... (keep existing AppBar) ...
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Request Details',
          style: AppTextStyles.h3.copyWith(color: AppColors.textDark),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Text(
              'Requested Amount',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
            ),
            SizedBox(height: 8.h),
            Text(
              amount,
              style: AppTextStyles.h1.copyWith(
                color: AppColors.textDark, 
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 24.h),
            
            // Status Tags
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      (request['status']?.toString().toUpperCase() ?? 'APPROVED'),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.successGreen, fontWeight: FontWeight.bold),
                    ),
                 ),
                 SizedBox(width: 10.w),
                 Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      (request['payment_status']?.toString().replaceAll('_', ' ').toUpperCase() ?? 'PENDING'),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.warningOrange, fontWeight: FontWeight.bold),
                    ),
                 ),
               ],
             ),

            SizedBox(height: 24.h),
            _buildRequesterCard(requestorName, requestorRole, requestId, date, purpose, description),
            SizedBox(height: 16.h),
            _buildBillAttachmentCard(receiptUrl, qrUrl),
            SizedBox(height: 20.h),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.onUseForPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('Process Payment', style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final dt = DateTime.parse(dateStr);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildRequesterCard(String name, String role, String id, String date, String purpose, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U', 
                  style: AppTextStyles.h3.copyWith(color: AppColors.primaryBlue, fontSize: 18.sp)
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Unknown User',
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      role.capitalizeFirst ?? 'Requestor',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Divider(height: 1.h),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('REQUEST ID', id),
              _buildInfoItem('DATE', date),
            ],
          ),
          SizedBox(height: 20.h),
          _buildInfoItem('PURPOSE', purpose),
          SizedBox(height: 20.h),
          Text(
            'DESCRIPTION',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate, letterSpacing: 1.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.5, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate, letterSpacing: 1.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBillAttachmentCard(String? billUrl, String? qrUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_file, color: AppColors.textSlate, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Bill & Attachments',
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildAttachmentButton(
                  'View Bill',
                  Icons.receipt_long,
                  billUrl != null ? () => Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_BILL_DETAILS, arguments: {'url': billUrl, 'title': 'Bill Details'}) : null,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildAttachmentButton(
                  'View QR',
                  Icons.qr_code_scanner,
                  qrUrl != null ? () => Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_BILL_DETAILS, arguments: {'url': qrUrl, 'title': 'QR Code'}) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(String label, IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
          boxShadow: [
             BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
               child: Icon(icon, color: AppColors.primaryBlue, size: 24.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: onTap != null ? AppColors.textDark : AppColors.textSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
