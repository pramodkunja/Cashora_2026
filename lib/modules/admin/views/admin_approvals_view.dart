import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/admin_approvals_controller.dart';
import 'widgets/admin_bottom_bar.dart';

class AdminApprovalsView extends GetView<AdminApprovalsController> {
  const AdminApprovalsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
         
          centerTitle: true,
          title: Text(AppText.approvalsTitle, style: AppTextStyles.h3),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined, color: AppColors.textDark, size: 24.sp)),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black26 : AppColors.backgroundAlt,
                borderRadius: BorderRadius.circular(20.r), // Pill shape for tab bar container
              ),
              child: TabBar(
                controller: controller.tabController,
                padding: EdgeInsets.zero,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8.r,
                      offset: Offset(0, 4.h),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab, // Ensures it fills the tab
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSlate,
                labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: AppText.tabPending),
                  Tab(text: AppText.tabApproved),
                  Tab(text: AppText.unpaid), // Replaces Rejected
                  Tab(text: AppText.clarification),
                ],
              ),
            ),
          ),
        ),
        body: Obx(() => TabBarView(
          controller: controller.tabController,
          children: [
            _buildRequestList(controller.pendingRequests),
            _buildRequestList(controller.approvedRequests),
            _buildRequestList(controller.unpaidRequests),
            _buildRequestList(controller.clarificationRequests),
          ],
        )),

    );
  }

  Widget _buildRequestList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Text(AppText.noRequests, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.all(24.r),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = items[index];
        
        // Data Extraction
        final String title = item['title']?.toString() ?? item['purpose']?.toString() ?? AppText.unnamedRequest;
        final String user = _getUserName(item);
        final String amount = (item['amount'] is num) ? (item['amount'] as num).toStringAsFixed(2) : (item['amount']?.toString() ?? '0.00');
        final String department = _getDepartment(item);
        final String status = (item['status']?.toString() ?? 'Pending').toUpperCase();

        String dateStr = item['date']?.toString() ?? item['created_at']?.toString() ?? '';
        if (dateStr.isNotEmpty) {
           try {
             final DateTime dt = DateTime.parse(dateStr);
             final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
             dateStr = '${months[dt.month - 1]} ${dt.day}';
           } catch (_) {
             if (dateStr.contains('T')) dateStr = dateStr.split('T')[0];
           }
        } else {
           dateStr = AppText.noDate;
        }

        return GestureDetector(
          onTap: () => controller.navigateToDetails(item),
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              children: [
                // TOP ROW: Icon + Title/Dept + Status/Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE), // Light Blue
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.inventory_2_outlined, color: AppColors.primaryBlue, size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    
                    // Title & Department
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                          SizedBox(height: 4.h),
                          Text(department, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    
                    // Status & Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: _getStatusColor(status).withOpacity(0.2)),
                          ),
                          child: Text(
                            status, 
                            style: TextStyle(
                              color: _getStatusColor(status), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 10.sp
                            )
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(dateStr, style: TextStyle(color: AppColors.textSlate, fontSize: 12.sp, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                
                SizedBox(height: 16.h),
                Divider(color: Theme.of(context).dividerColor.withOpacity(0.5)),
                SizedBox(height: 16.h),
                
                // BOTTOM ROW: User + Amount
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User Info
                    Row(
                      children: [
                         CircleAvatar(
                          radius: 18.r,
                          backgroundColor: const Color(0xFFF1F5F9), // Slate 100
                          child: Text(_getInitials(user), style: TextStyle(fontSize: 12.sp, color: const Color(0xFF64748B), fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Requested by", style: TextStyle(color: AppColors.textSlate, fontSize: 11.sp)),
                            SizedBox(height: 2.h),
                            Text(user, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                          ],
                        ),
                      ],
                    ),
                    
                    // Amount
                    Text(
                      '₹$amount', 
                      style: AppTextStyles.h1.copyWith(fontSize: 20.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getDepartment(Map<String, dynamic> item) {
    // 1. Check top-level
    if (item['department'] != null && item['department'].toString().isNotEmpty) return item['department'].toString();
    if (item['department_name'] != null && item['department_name'].toString().isNotEmpty) return item['department_name'].toString();

    // 2. Check nested 'requestor'
    if (item['requestor'] != null && item['requestor'] is Map) {
      final r = item['requestor'];
      if (r['department'] != null) return r['department'].toString();
      if (r['department_name'] != null) return r['department_name'].toString();
    }

    // 3. Check nested 'user'
    if (item['user'] != null && item['user'] is Map) {
      final u = item['user'];
       if (u['department'] != null) return u['department'].toString();
    }
    
    // 4. Return reasonable default if truly missing, but user implies data should be there.
    return 'General'; 
  }

  String _getUserName(Map<String, dynamic> item) {
    // Check specific keys first
    if (item['user_name'] != null && item['user_name'].toString().isNotEmpty) return item['user_name'].toString();
    if (item['employee_name'] != null && item['employee_name'].toString().isNotEmpty) return item['employee_name'].toString();
    
    // Check nested 'requestor' object (Primary)
    if (item['requestor'] != null) {
      if (item['requestor'] is Map) {
         final r = item['requestor'];
         final String firstName = r['first_name']?.toString() ?? '';
         final String lastName = r['last_name']?.toString() ?? '';
         if (firstName.isNotEmpty) {
           return "$firstName $lastName".trim();
         }
         if (r['email'] != null) return r['email'].toString().split('@').first;
      }
    }

    if (item['requestor_name'] != null && item['requestor_name'].toString().isNotEmpty) return item['requestor_name'].toString();

    // Check nested 'user' object
    if (item['user'] != null) {
      if (item['user'] is Map) {
         final u = item['user'];
         if (u['name'] != null) return u['name'].toString();
         if (u['full_name'] != null) return u['full_name'].toString();
         if (u['first_name'] != null) return "${u['first_name']} ${u['last_name'] ?? ''}".trim();
         if (u['email'] != null) return u['email'].toString().split('@').first;
      } else if (item['user'] is String) {
         return item['user'];
      }
    }
    
    // Check nested 'employee' object
    if (item['employee'] != null) {
      if (item['employee'] is Map) {
         return item['employee']['name']?.toString() ?? item['employee']['first_name']?.toString() ?? 'Unknown';
      } else if (item['employee'] is String) {
         return item['employee'];
      }
    }

    return AppText.unknownUser;
  }
  
  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    List<String> parts = name.trim().split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'auto_approved':
        return AppColors.successGreen;
      case 'rejected':
        return AppColors.error;
      case 'clarification_required': 
        return Colors.orange;
      case 'paid':
        return Colors.purple;
      default:
        return const Color(0xFFF59E0B); // Pending Orange/Amber
    }
  }
}
