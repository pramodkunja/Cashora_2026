import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Lock Icon Badge
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE), // Light Blue bg
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset_outlined,
                size: 40,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              'Forgot Password', // AppText.forgotPasswordTitle
              style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Enter your email or phone number to receive a verification code.', // AppText.forgotPasswordSubtitle
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            
            // Input Field
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.textSlate),
                hintText: 'Email or Phone Number', // AppText.emailOrPhone 
                hintStyle: TextStyle(color: AppColors.textSlate.withOpacity(0.7)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC), // Very light grey/white
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
              ),
            ),
            const SizedBox(height: 40), // Spacing before button
            
            // Send OTP Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.sendCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0EA5E9), // Sky Blue (Primary)
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Send OTP', // AppText.sendCode
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Footer Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Remember your password? ',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                ),
                GestureDetector(
                  onTap: () => Get.back(), // Or Get.offNamed(AppRoutes.LOGIN)
                  child: Text(
                    'Log In',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF0EA5E9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
