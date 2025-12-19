import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppText.resetPassword,
          style: AppTextStyles.h3,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  AppText.createNewPassword,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.h2,
                ),
                const SizedBox(height: 12),
                Text(
                  AppText.newPasswordMustBeDifferent,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                ),
                const SizedBox(height: 32),

                // New Password Field
                Text(
                  AppText.newPassword,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                  controller: controller.newPasswordController,
                  obscureText: !controller.isNewPasswordVisible.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textLight, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      onPressed: controller.toggleNewPasswordVisibility,
                    ),
                    hintText: AppText.enterNewPassword,
                    hintStyle: AppTextStyles.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                )),
                const SizedBox(height: 24),

                // Confirm Password Field
                Text(
                  AppText.confirmPassword,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textLight, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmPasswordVisible.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textLight,
                        size: 20,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                    hintText: AppText.confirmNewPassword,
                    hintStyle: AppTextStyles.hintText,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppColors.primaryBlue),
                    ),
                  ),
                )),
                const SizedBox(height: 60),

                // Update Button
                Obx(() => PrimaryButton(
                  text: AppText.updatePassword,
                  onPressed: controller.updatePassword,
                  isLoading: controller.isLoading,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
