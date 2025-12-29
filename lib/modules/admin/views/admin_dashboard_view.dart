import 'package:flutter/material.dart';
import 'widgets/welcome_message.dart';
import '../../../../utils/date_helper.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_bottom_bar.dart';
import 'widgets/admin_action_card.dart';
import 'widgets/admin_overview_card.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({Key? key}) : super(key: key);

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeMessage(
                name: controller.shortName,
                showWelcome: controller.showWelcome,
              ),
              const SizedBox(height: 24),

              Text(AppText.overview, style: AppTextStyles.h3),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: AdminOverviewCard(
                      title: AppText.pending,
                      count: '12',
                      isMoney: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AdminOverviewCard(
                      title: AppText.approved,
                      count: '₹1,250',
                      isMoney: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text(AppText.actions, style: AppTextStyles.h3),
              const SizedBox(height: 16),

              AdminActionCard(
                icon: Icons.hourglass_empty_rounded,
                iconBg:
                    AppColors.primaryBlue, // Pass opaque, Card handles opacity
                iconColor: AppColors.primaryBlue,
                title: AppText.reviewPending,
                subtitle: AppText.viewAllRequests,
                onTap: controller.navigateToApprovals,
              ),
              const SizedBox(height: 16),
              AdminActionCard(
                icon: Icons.history_rounded,
                iconBg: AppColors.primaryBlue, // Pass opaque
                iconColor: AppColors.primaryBlue,
                title: AppText.viewHistory,
                subtitle: AppText.pastApprovals,
                onTap: () {
                  controller.changeTab(2); // History Tab
                },
              ),
              const SizedBox(height: 16),
              // Add New User (Placed 3rd as requested "under view history")
              AdminActionCard(
                icon: Icons.person_add_alt_1_rounded,
                iconBg: AppColors.primaryBlue, // Match theme
                iconColor: AppColors.primaryBlue,
                title: AppText.addNewUser,
                subtitle: AppText.createNewAccount,
                onTap: () {
                  Get.toNamed(AppRoutes.ADMIN_ADD_USER);
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
