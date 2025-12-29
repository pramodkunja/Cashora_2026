import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../../../utils/widgets/buttons/secondary_button.dart';
import '../controllers/requestor_controller.dart';
import 'widgets/requestor_bottom_bar.dart';
import '../../admin/views/widgets/welcome_message.dart';
import '../../../../utils/date_helper.dart';

class RequestorDashboardView extends GetView<RequestorController> {
  const RequestorDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text('Hello,', style: AppTextStyles.h3)),
                      const SizedBox(width: 4),
                      // Dynamic user greeting
                      Flexible(
                        child: Obx(
                          () => Text(
                            '${controller.shortName}!',
                            style: AppTextStyles.h3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateHelper.getFormattedDate(),
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.ADMIN_NOTIFICATIONS),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 0.0,
          bottom: 40.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeMessage(
              name: controller.shortName,
              showWelcome: controller.showWelcome,
            ),
            // _buildTopBar(), // Removed
            // const SizedBox(height: 16), // Removed
            //   Obx(() => Text( // Removed Greeting
            //     'Hello, ${controller.userName}',
            //     style: TextStyle(
            //       fontSize: 28,
            //       fontWeight: FontWeight.w700,
            //       color: AppTextStyles.h1.color,
            //     ),
            //   )),
            // const SizedBox(height: 24), // Removed
            const SizedBox(height: 24),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildMonthlyExpenseCard(context),
            const SizedBox(height: 24),
            _buildPendingRequestsCard(context),
            const SizedBox(height: 24),
            Text(
              'Recent Requests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTextStyles.h2.color,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecentRequestsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: AppText.newRequest,
            onPressed: () => Get.toNamed(AppRoutes.CREATE_REQUEST_TYPE),
            icon: const Icon(Icons.add_circle, size: 20, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        // Example for future: SecondaryButton usage
        Expanded(
          child: SecondaryButton(
            text: AppText.uploadBill,
            onPressed: () {
              // Future implementation
            },
            icon: const Icon(
              Icons.upload_file,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyExpenseCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppText.monthlyExpense,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppTextStyles.bodyMedium.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This Month\'s Spending', // Could be dynamic
            style: AppTextStyles.h3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('₹350.50', style: AppTextStyles.h1.copyWith(fontSize: 32)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  '/ ₹1000 ${AppText.limit}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.35, // 350/1000
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => Get.toNamed(AppRoutes.MONTHLY_SPENT),
            child: Text(
              AppText.viewDetails,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingRequestsCard(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.MY_REQUESTS, arguments: {'filter': 'Pending'}),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.pending_actions,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppText.pendingApprovals,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '3 ${AppText.requestsWaiting}', // Dynamic count
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            SecondaryButton(
              text: 'View All',
              onPressed: () => Get.toNamed(
                AppRoutes.MY_REQUESTS,
                arguments: {'filter': 'Pending'},
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRequestsList() {
    return Obx(() {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.recentRequests.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = controller.recentRequests[index];
          return GestureDetector(
            onTap: () =>
                Get.toNamed(AppRoutes.REQUEST_DETAILS_READ, arguments: item),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: item['color'] as Color, // e.g., Colors.blue[100]
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['iconColor'] as Color,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTextStyles.h3.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['date'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${(item['amount'] as double).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTextStyles.h3.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            item['status'] as String,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(item['status'] as String),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Color _getStatusColor(String status) {
    if (status == 'Approved') return AppColors.success;
    if (status == 'Rejected') return AppColors.error;
    return AppColors.warning;
  }
}
