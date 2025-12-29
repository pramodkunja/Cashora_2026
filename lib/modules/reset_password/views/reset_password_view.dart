import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
            
            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Lock Icon Badge
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.infoBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    Text(
                      'Reset Password',
                      style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Your new password must be different from previously used passwords.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // New Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('New Password'),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => TextField(
                      controller: controller.newPasswordController,
                      obscureText: controller.isNewPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: 'Enter new password',
                        isObscure: controller.isNewPasswordHidden.value,
                        onToggleVisibility: controller.toggleNewPasswordVisibility,
                      ),
                    )),
                    
                    const SizedBox(height: 24),
                    
                    // Confirm Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildLabel('Confirm Password'),
                    ),
                    const SizedBox(height: 8),
                     Obx(() => TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      decoration: _inputDecoration(
                        hint: 'Confirm new password',
                        isObscure: controller.isConfirmPasswordHidden.value,
                        onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                      ),
                    )),
                    
                    const SizedBox(height: 48),
                    
                    // Update Button
                     Obx(() => SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading ? null : controller.resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Update Password', 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)), // Slate 400
      prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFF94A3B8)),
      suffixIcon: IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: const Color(0xFF94A3B8),
        ),
        onPressed: onToggleVisibility,
        color: const Color(0xFF94A3B8), 
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), 
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), 
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16), 
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
