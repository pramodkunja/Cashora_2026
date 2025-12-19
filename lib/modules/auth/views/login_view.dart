import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FC), // Light blueish grey background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Shield Icon
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.security_rounded,
                      color: Color(0xFF0284C7), // Light Blue
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Welcome Text
                Text(
                  AppText.welcomeBack,
                  style: AppTextStyles.h1,
                ),
                const SizedBox(height: 8),
                Text(
                  AppText.signInSubtitle,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSlate),
                ),
                const SizedBox(height: 32),

                // Email Input
                Text(
                  AppText.emailAddress,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    hintText: AppText.emailPlaceholder,
                    hintStyle: AppTextStyles.hintText,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textLight),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                const SizedBox(height: 20),

                // Password Input
                Text(
                  AppText.password,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
                ),
                const SizedBox(height: 8),
                Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: AppText.passwordPlaceholder,
                    hintStyle: AppTextStyles.hintText,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textLight),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textLight,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
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
                )),
                
                // Forgot Password
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppText.forgotPassword,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Login Button
                Obx(() => PrimaryButton(
                  text: AppText.signIn,
                  onPressed: controller.login,
                  isLoading: controller.isLoading,
                )),
                const SizedBox(height: 60),

                // Enterprise Setup Footer
                Row(
                  children: [
                    const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppText.enterpriseSetup,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF94A3B8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.ORGANIZATION_SETUP),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.domain_add_outlined, color: Color(0xFF475569), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppText.setUpOrganization,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                //  Center(
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       const Icon(Icons.lock_rounded, color: Color(0xFFCBD5E1), size: 14),
                //       const SizedBox(width: 6),
                //        Text(
                //         'Secured by Enterprise ID',
                //         style: GoogleFonts.inter(
                //           color: const Color(0xFFCBD5E1),
                //           fontSize: 12,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
