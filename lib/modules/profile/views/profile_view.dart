import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../controllers/profile_controller.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../../../routes/app_routes.dart';
import '../../admin/views/widgets/admin_bottom_bar.dart';
// Needs custom layout for list items as per image (Icon box left, Text, Arrow)

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundLight, // Removed to use Theme default
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Get.offNamed(AppRoutes.ADMIN_DASHBOARD),
        ),
        centerTitle: true,
        title: Text(AppText.myProfile, style: AppTextStyles.h3),
        actions: [
          TextButton(
            onPressed: controller.editProfile,
            child: Text(AppText.edit, style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryBlue)),
          )
        ],
      ),
      bottomNavigationBar: AdminBottomBar(
        currentIndex: 3, 
        onTap: (index) {
          if (index == 0) Get.offNamed(AppRoutes.ADMIN_DASHBOARD);
          if (index == 1) Get.offNamed(AppRoutes.ADMIN_APPROVALS);
          if (index == 2) Get.offNamed(AppRoutes.ADMIN_HISTORY);
          if (index == 3) { /* Current Page */ } 
        }
      ), // Profile Tab
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.lightBlue.shade100, width: 4),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orangeAccent,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'), // Mock
                // child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(controller.rxName.value, style: AppTextStyles.h2)),
            const SizedBox(height: 4),
            Obx(() => Text(controller.rxEmail.value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate))),
            
            const SizedBox(height: 32),

            // Info Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: AppColors.primaryBlue,
                    label: AppText.fullName,
                    value: controller.rxName.value,
                  ),
                  const Divider(height: 24),
                  _buildInfoTile(
                    icon: Icons.email,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: AppColors.primaryBlue,
                    label: AppText.emailAddress, // Or 'Email'
                    value: controller.rxEmail.value,
                  ),
                  const Divider(height: 24),
                  _buildInfoTile(
                    icon: Icons.phone,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: AppColors.primaryBlue,
                    label: AppText.phone,
                    value: controller.rxPhone.value,
                  ),
                  const Divider(height: 24),
                  _buildInfoTile(
                    icon: Icons.badge,
                    iconBg: const Color(0xFFE0F2FE),
                    iconColor: AppColors.primaryBlue,
                    label: AppText.role,
                    value: controller.rxRole.value,
                    showArrow: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
                 decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildActionTile(
                      icon: Icons.people_outline_rounded,
                      iconBg: const Color(0xFFF0FDF4), // Light Green
                      iconColor: const Color(0xFF16A34A), // Green
                      title: AppText.manageUsers,
                      onTap: controller.navigateToManageUsers,
                    ),
                ],
              ),
              
            ),
            const SizedBox(height: 24),

            
            // Actions Card
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                   _buildActionTile(
                     icon: Icons.lock,
                     iconBg: const Color(0xFFE0F2FE),
                     iconColor: AppColors.primaryBlue,
                     title: AppText.changePassword,
                     onTap: controller.navigateToChangePassword,
                   ),
                   const Divider(height: 24),
                   _buildActionTile(
                     icon: Icons.settings,
                     iconBg: const Color(0xFFE0F2FE),
                     iconColor: AppColors.primaryBlue,
                     title: AppText.appSettings,
                     onTap: controller.navigateToSettings,
                   ),
                    
                  
                ],
              ),
            ),
            
             const SizedBox(height: 40),
             TextButton.icon(
               onPressed: controller.logout,
               icon: const Icon(Icons.logout, color: Colors.red),
               label: Text(AppText.logOut, style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
             ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    bool showArrow = true,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg.withOpacity(Get.isDarkMode ? 0.2 : 1.0), // Adjust for dark mode visibility
            shape: BoxShape.circle
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodySmall.color, fontSize: 12)),
              const SizedBox(height: 4),
              Text(value, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            ],
          ),
        ),
        if (showArrow)
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTextStyles.bodySmall.color),
      ],
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg.withOpacity(Get.isDarkMode ? 0.2 : 1.0),
              shape: BoxShape.circle
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppTextStyles.bodySmall.color),
        ],
      ),
    );
  }
}
