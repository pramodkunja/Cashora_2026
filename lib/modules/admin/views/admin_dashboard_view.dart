import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../controllers/admin_dashboard_controller.dart';
import 'widgets/admin_bottom_bar.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.backgroundLight,
              pinned: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              toolbarHeight: 70, // Height to fit the custom row comfortably
              titleSpacing: 24,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryBlue,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      // Empty container or small column if we want the "Dashboard" here? 
                      // User said "dashboard title should be there onoly".
                      // Original design had "Dashboard" center or part of row.
                      // Let's stick to the previous Row layout but inside the Title.
                    ],
                  ),
                  Text(AppText.dashboard, style: AppTextStyles.h3),
                  IconButton(
                    icon: const Icon(Icons.settings, color: AppColors.textDark),
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

                    // Overview Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildOverviewCard(
                            title: AppText.pending,
                            count: '12',
                            isMoney: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildOverviewCard(
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

                    // Action Cards
                    _buildActionCard(
                      icon: Icons.hourglass_empty_rounded,
                      iconBg: const Color(0xFFE0F2FE), // Light Blue
                      iconColor: AppColors.primaryBlue,
                      title: AppText.reviewPending,
                      subtitle: AppText.viewAllRequests,
                      onTap: controller.navigateToApprovals,
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      icon: Icons.history_rounded,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: AppColors.primaryBlue,
                      title: AppText.viewHistory,
                      subtitle: AppText.pastApprovals,
                      onTap: () {}, // TODO
                    ),
                    const SizedBox(height: 32), // Bottom spacing
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
          if (index != 0) controller.changeTabIndex(index);
        },
      ),
    );
  }

  Widget _buildOverviewCard({required String title, required String count, required bool isMoney}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Slightly darker shadow
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: AppTextStyles.h1.copyWith(
              color: isMoney ? AppColors.primaryBlue : AppColors.textDark,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // Slightly darker shadow
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: AppColors.textSlate, size: 20),
          ],
        ),
      ),
    );
  }
}
