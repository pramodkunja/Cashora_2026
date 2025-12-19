import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0F2FE), // Light Blue
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.lock_reset_rounded,
                              color: Color(0xFF0EA5E9),
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
      
                      // Title
                      Text(
                        AppText.forgotPasswordTitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 12),
      
                      // Subtitle
                      Text(
                        AppText.forgotPasswordSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 32),
      
                      // Input Field
                      TextField(
                        controller: controller.inputController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.textSlate, size: 20),
                          hintText: AppText.emailOrPhone,
                          hintStyle: AppTextStyles.hintText,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.borderLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.borderLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primaryBlue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
      
                      // Send OTP Button
                      Obx(() => PrimaryButton(
                        text: AppText.sendCode,
                        onPressed: controller.sendOtp,
                        isLoading: controller.isLoading,
                      )),
                      const SizedBox(height: 24),
      
                      // Back to Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppText.rememberPassword,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF64748B),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              AppText.logIn,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0EA5E9),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 120), // Push content upward
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
