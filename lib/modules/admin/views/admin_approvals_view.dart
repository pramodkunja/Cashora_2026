import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(AppText.approvalsTitle, style: AppTextStyles.h3),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark)),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black26 : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20), // Pill shape for tab bar container
              ),
              child: TabBar(
                padding: EdgeInsets.zero,
                isScrollable: false,
                indicator: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
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
                  Tab(text: AppText.tabRejected),
                  Tab(text: AppText.clarification),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestList(controller.pendingRequests),
            _buildRequestList(controller.approvedRequests),
            _buildRequestList(controller.rejectedRequests),
            _buildRequestList(controller.clarificationRequests),
          ],
        ),
        bottomNavigationBar: AdminBottomBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 1) return;
            switch (index) {
              case 0: Get.offNamed(AppRoutes.ADMIN_DASHBOARD); break;
              case 2: Get.offNamed(AppRoutes.ADMIN_HISTORY); break;
              case 3: Get.offNamed(AppRoutes.PROFILE); break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildRequestList(List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return Center(
        child: Text("No requests", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => controller.navigateToDetails(item),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'], style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('${AppText.from} ${item['user']}', style: AppTextStyles.bodyMedium),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item['amount']}', 
                      style: AppTextStyles.h3.copyWith(color: AppColors.primaryBlue, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date'],
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
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
