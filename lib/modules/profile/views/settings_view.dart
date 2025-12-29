import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../controllers/settings_controller.dart';
import '../../../../utils/widgets/custom_list_tile.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTextStyles.h3.color),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(AppText.settings, style: AppTextStyles.h3), // 'Settings'
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
           

            // Settings Group 1
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  CustomListTile(
                    title: AppText.notifications,
                    leadingIconWidget: const Icon(Icons.notifications, color: AppColors.primaryBlue),
                    onTap: controller.navigateToNotifications,
                  ),
                  CustomListTile(
                    title: AppText.currency,
                    leadingIconWidget: const Icon(Icons.currency_pound, color: AppColors.primaryBlue),
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: AppText.appearance,
                    leadingIconWidget: const Icon(Icons.contrast, color: AppColors.primaryBlue),
                    onTap: controller.navigateToAppearance,
                    showDivider: false,
                  ),
                ],
              ),
            ),
             const SizedBox(height: 24),

             // Settings Group 2 (Face ID & Password)
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                   // Face ID Toggle
                   ListTile(
                     contentPadding: EdgeInsets.zero,
                     leading: const Icon(Icons.fingerprint, color: AppColors.primaryBlue),
                     title: Text(AppText.faceIdTouchId, style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.h3.color)),
                     trailing: Obx(() => Switch(
                       value: controller.rxFaceIdEnabled.value, 
                       onChanged: controller.toggleFaceId,
                       activeColor: AppColors.primaryBlue,
                       inactiveThumbColor: Colors.grey.shade400,
                       inactiveTrackColor: Colors.grey.shade200,
                     )),
                   ),
                   const Divider(height: 1),
                   CustomListTile(
                    title: AppText.changePassword,
                    leadingIconWidget: const Icon(Icons.lock, color: AppColors.primaryBlue),
                    onTap: controller.navigateToChangePassword,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings Group 3
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  CustomListTile(
                    title: AppText.helpSupport,
                    leadingIconWidget: const Icon(Icons.help, color: AppColors.primaryBlue),
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: AppText.privacyPolicy,
                    leadingIconWidget: const Icon(Icons.security, color: AppColors.primaryBlue),
                    onTap: () {},
                  ),
                  CustomListTile(
                    title: AppText.termsOfService,
                    leadingIconWidget: const Icon(Icons.description, color: AppColors.primaryBlue),
                    onTap: () {},
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Logout Button (Full width blue light)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: controller.logout,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFD1F2FA), // Light blue from image
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                child: Text(AppText.logOut, style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryBlue)),
              ),
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
