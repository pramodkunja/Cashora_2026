import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../profile/controllers/settings_controller.dart';

class AppearanceView extends GetView<SettingsController> {
  const AppearanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Appearance', style: AppTextStyles.h3), // AppText.appearance
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match scaffold
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTextStyles.h3.color, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppText.appTheme, style: AppTextStyles.h3.copyWith(fontSize: 14)),
            const SizedBox(height: 16),
            
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                   Obx(() => Column(
                     children: [
                       GestureDetector(
                         onTap: () => controller.selectTheme(0),
                         child: _buildThemeOption(context, Icons.light_mode, AppText.lightTheme, controller.rxPendingThemeMode.value == 0, Colors.orange),
                       ),
                       const Divider(),
                       GestureDetector(
                         onTap: () => controller.selectTheme(1),
                         child: _buildThemeOption(context, Icons.dark_mode, AppText.darkTheme, controller.rxPendingThemeMode.value == 1, Colors.indigo),
                       ),
                       const Divider(),
                       GestureDetector(
                         onTap: () => controller.selectTheme(2),
                         child: _buildThemeOption(context, Icons.settings, AppText.systemDefault, controller.rxPendingThemeMode.value == 2, Colors.blue),
                       ),
                     ],
                   )),
                ],
              ),
            ),

            // Removed Text Size and Preview as requested
            const SizedBox(height: 40),
            PrimaryButton(
              text: AppText.saveChanges,
              onPressed: controller.saveThemeChanges,
            ),
             const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, IconData icon, String label, bool selected, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
           Container(
             padding: const EdgeInsets.all(10),
             decoration: BoxDecoration(
               color: iconColor.withOpacity(0.1),
               shape: BoxShape.circle,
             ),
             child: Icon(icon, color: iconColor, size: 20),
           ),
           const SizedBox(width: 16),
           Expanded(child: Text(label, style: AppTextStyles.h3.copyWith(fontSize: 16))),
           Container(
             width: 20, height: 20,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               border: Border.all(color: selected ? AppColors.primaryBlue : Theme.of(context).dividerColor, width: 2),
               color: selected ? Theme.of(context).cardColor : Colors.transparent,
             ),
             child: selected 
              ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppColors.primaryBlue, shape: BoxShape.circle)))
              : null,
           ),
        ],
      ),
    );
  }
}
