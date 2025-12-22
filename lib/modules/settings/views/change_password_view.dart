import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../profile/controllers/settings_controller.dart';

class ChangePasswordView extends GetView<SettingsController> {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Change Password', style: AppTextStyles.h3),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text('Your new password must be different from previous used passwords.', 
                style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodyMedium.color)),
             const SizedBox(height: 24),

             _buildLabel(AppText.currentPassword),
             _buildPasswordField(context, AppText.enterCurrentPassword, controller.currentPasswordController),
             const SizedBox(height: 20),

             _buildLabel(AppText.newPassword),
             _buildPasswordField(context, AppText.enterNewPassword, controller.newPasswordController),
             const SizedBox(height: 6),
             Obx(() => Row(
               children: [
                 Icon(
                   controller.rxPasswordLength.value ? Icons.check_circle : Icons.info, 
                   size: 14, 
                   color: controller.rxPasswordLength.value ? Colors.green : AppColors.textSlate
                 ),
                 const SizedBox(width: 6),
                 Text(AppText.mustBeAtLeast8Chars, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: controller.rxPasswordLength.value ? Colors.green : AppColors.textSlate)),
               ],
             )),

             const SizedBox(height: 20),
             _buildLabel(AppText.confirmNewPassword),
             _buildPasswordField(context, AppText.reEnterNewPassword, controller.confirmPasswordController),
             const SizedBox(height: 6),
             Obx(() => Row(
               children: [
                 Icon(
                   controller.rxPasswordMatch.value ? Icons.check_circle : Icons.info, 
                   size: 14, 
                   color: controller.rxPasswordMatch.value ? Colors.green : AppColors.textSlate
                 ), 
                 const SizedBox(width: 6),
                 Text(AppText.bothPasswordsMatch, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: controller.rxPasswordMatch.value ? Colors.green : AppColors.textSlate)),
               ],
             )),

             const SizedBox(height: 48),
             PrimaryButton(text: AppText.updatePassword, onPressed: controller.changePassword),
             const SizedBox(height: 16),
             Center(child: TextButton(onPressed: (){}, child: Text(AppText.forgotPasswordQuestion, style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryBlue)))),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
     return Padding(
       padding: const EdgeInsets.only(bottom: 8.0, left: 4),
       child: Text(text, style: AppTextStyles.h3.copyWith(fontSize: 14)),
     );
  }

  Widget _buildPasswordField(BuildContext context, String hint, TextEditingController fieldController) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: TextField(
        controller: fieldController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          suffixIcon: const Icon(Icons.visibility_off_outlined, color: AppColors.textLight),
        ),
      ),
    );
  }
}
