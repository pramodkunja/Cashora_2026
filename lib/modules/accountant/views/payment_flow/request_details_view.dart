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
    // Get request data from arguments or controller
    final Map<String, dynamic> request = controller.currentRequest.isNotEmpty 
        ? controller.currentRequest 
        : (Get.arguments is Map ? (Get.arguments['request'] ?? {}) : {});
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // ... (keep existing AppBar) ...
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Request Details',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Theme.of(context).iconTheme.color),
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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.h),
            Text(
              amount,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
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
            _buildRequesterCard(context, requestorName, requestorRole, requestId, date, purpose, description),
            SizedBox(height: 16.h),
            _buildBillAttachmentCard(context, receiptUrl, qrUrl),
            SizedBox(height: 20.h),
            
            // Action Button
            SizedBox.shrink(),
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

  Widget _buildRequesterCard(BuildContext context, String name, String role, String id, String date, String purpose, String description) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
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
              _buildInfoItem(context, 'REQUEST ID', id),
              _buildInfoItem(context, 'DATE', date),
            ],
          ),
          SizedBox(height: 20.h),
          _buildInfoItem(context, 'PURPOSE', purpose),
          SizedBox(height: 20.h),
          Text(
            'DESCRIPTION',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate, letterSpacing: 1.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
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
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBillAttachmentCard(BuildContext context, String? billUrl, String? qrUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
                    context,
                    'View Bill',
                    Icons.receipt_long,
                    billUrl != null ? () {
                      controller.prepareForView(
                        url: billUrl, 
                        title: 'Bill Details', 
                        isQr: false
                      );
                      Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_BILL_DETAILS, arguments: {
                        'url': billUrl, 
                        'title': 'Bill Details',
                        'isQr': false,
                        'request': controller.currentRequest.value
                      });
                    } : null,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildAttachmentButton(
                    context,
                    'View QR',
                    Icons.qr_code_scanner,
                    qrUrl != null ? () {
                      controller.prepareForView(
                        url: qrUrl, 
                        title: 'Scan QR Code', 
                        isQr: true
                      );
                      Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_BILL_DETAILS, arguments: {
                        'url': qrUrl, 
                        'title': 'Scan QR Code',
                        'isQr': true,
                         'request': controller.currentRequest.value
                      });
                    } : null,
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(BuildContext context, String label, IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100.h,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: onTap != null ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
