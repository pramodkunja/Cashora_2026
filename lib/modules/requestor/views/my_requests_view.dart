import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/my_requests_controller.dart';
import '../../../../core/widgets/common_search_bar.dart';
import 'widgets/requestor_bottom_bar.dart'; 
import '../../../../utils/app_text.dart'; 
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_colors.dart'; 

class MyRequestsView extends GetView<MyRequestsController> {
  const MyRequestsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if arguments passed to set initial tab
    if (Get.arguments != null && Get.arguments['filter'] == 'Pending') {
      controller.changeTab(1);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppText.myRequests, style: TextStyle(color: AppTextStyles.h3.color, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [], // Removed search icon
        automaticallyImplyLeading: false, 
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CommonSearchBar(
                hintText: AppText.searchRequests,
                onChanged: controller.searchRequests,
              ),
            ),

            // Tabs
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark ? Colors.black26 : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Obx(() => Row(
                children: [
                  _buildTab(context, AppText.filterAll, 0),
                  _buildTab(context, AppText.filterPending, 1),
                  _buildTab(context, AppText.filterApproved, 2),
                  _buildTab(context, AppText.filterRejected, 3),
                ],
              )),
            ),

            // List
            Expanded(
              child: Obx(() => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredRequests.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final req = controller.filteredRequests[index];
                  return _buildRequestCard(context, req);
                },
              )),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.CREATE_REQUEST_TYPE),
        backgroundColor: const Color(0xFF0EA5E9),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: RequestorBottomBar(
        currentIndex: 1,
        onTap: (index) {
           if (index == 0) {
             Get.offNamed(AppRoutes.REQUESTOR);
           }
           if (index == 1) return; // Already here
           if (index == 2) {
              Get.snackbar(AppText.comingSoon, AppText.profileUnderConstruction);
           }
        }
      ), 
    );
  }

  Widget _buildTab(BuildContext context, String title, int index) {
    bool isSelected = controller.currentTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).cardColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primaryBlue : AppTextStyles.bodyMedium.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, Map<String, dynamic> req) {
    Color statusColor;
    Color statusBg;
    
    switch (req['status']) {
      case 'Approved':
        statusColor = const Color(0xFF15803D);
        statusBg = const Color(0xFFDCFCE7);
        break;
      case 'Pending':
        statusColor = const Color(0xFFB45309);
        statusBg = const Color(0xFFFEF3C7);
        break;
      case 'Rejected':
        statusColor = const Color(0xFFB91C1C);
        statusBg = const Color(0xFFFEE2E2);
        break;
      default:
        statusColor = Colors.grey;
        statusBg = Colors.grey[200]!;
    }

    return GestureDetector(
      onTap: () => controller.viewDetails(req),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: req['iconBg'], borderRadius: BorderRadius.circular(12)),
              child: Icon(req['icon'], color: req['iconColor']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                  const SizedBox(height: 4),
                  Text(req['date'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${req['amount'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTextStyles.h3.color)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(12)),
                  child: Text(req['status'], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
