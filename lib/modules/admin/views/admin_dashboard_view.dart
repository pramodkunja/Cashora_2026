import 'package:flutter/material.dart';
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
      // backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70,
              titleSpacing: 24,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.PROFILE),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primaryBlue,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const SizedBox(width: 8),
                    ],
                  ),
                  Text(AppText.dashboard, style: AppTextStyles.h3),
                  IconButton(
                    icon: Icon(Icons.settings, color: AppTextStyles.h3.color),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(AppText.welcomeApprover, style: AppTextStyles.h1),
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
                            count: '\$1,250',
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
                      iconBg: AppColors.primaryBlue, // Pass opaque, Card handles opacity
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
                         Get.toNamed(AppRoutes.ADMIN_HISTORY);
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
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          switch (index) {
            case 1: Get.offNamed(AppRoutes.ADMIN_APPROVALS); break;
            case 2: Get.offNamed(AppRoutes.ADMIN_HISTORY); break;
            case 3: Get.offNamed(AppRoutes.PROFILE); break;
          }
        },
      ),
    );
  }
}
