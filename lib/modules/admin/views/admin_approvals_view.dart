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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
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
                padding: EdgeInsets.zero,
                isScrollable: false,
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
          children: [
            _buildRequestList(controller.pendingRequests),
            _buildRequestList(controller.approvedRequests),
            _buildRequestList(controller.unpaidRequests),
            _buildRequestList(controller.clarificationRequests),
          ],
        )),

      ),
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
        
        // Robust Extraction
        final String title = item['title']?.toString() ?? item['purpose']?.toString() ?? AppText.unnamedRequest;
        final String user = item['user']?.toString() ?? item['employee_name']?.toString() ?? AppText.unknownUser;
        final String amount = (item['amount'] is num) ? (item['amount'] as num).toStringAsFixed(2) : (item['amount']?.toString() ?? '0.00');
        
        String dateStr = item['date']?.toString() ?? item['created_at']?.toString() ?? '';
        if (dateStr.isNotEmpty) {
           try {
             final DateTime dt = DateTime.parse(dateStr);
             final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
             dateStr = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
           } catch (_) {
             if (dateStr.contains('T')) dateStr = dateStr.split('T')[0];
           }
        } else {
           dateStr = AppText.noDate;
        }

        return GestureDetector(
          onTap: () => controller.navigateToDetails(item),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Added Expanded to avoid overflow with long titles
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16.sp), maxLines: 1, overflow: TextOverflow.ellipsis),
                      SizedBox(height: 4.h),
                      Text('${AppText.from} $user', style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹$amount', 
                      style: AppTextStyles.h3.copyWith(color: AppColors.primaryBlue, fontSize: 16.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateStr,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.sp),
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
}
