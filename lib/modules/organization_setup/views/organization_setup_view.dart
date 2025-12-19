import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Retain for now if generic text field styles need specific GoogleFonts calls, but aiming to remove.
import '../controllers/organization_setup_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';

class OrganizationSetupView extends GetView<OrganizationSetupController> {
  const OrganizationSetupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSlate),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppText.setupOrganization,
          style: AppTextStyles.h3,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stepper UI
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStep(1, AppText.stepperOrganization, isActive: true),
                    Container(
                      width: 40,
                      height: 1,
                      color: AppColors.borderLight,
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    _buildStep(2, AppText.stepperPreferences, isActive: false),
                  ],
                ),
                const SizedBox(height: 32),

                // Organization Details Section
                Text(
                  AppText.organizationDetails,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel(AppText.organizationName),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.orgNameController,
                  hint: AppText.hintOrgName,
                ),
                const SizedBox(height: 20),

                _buildLabel(AppText.organizationCode),
                const SizedBox(height: 8),
                Obx(() => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // Light grey background for readonly
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.orgCode.value,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSlate,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(Icons.copy_rounded, size: 20, color: AppColors.primaryBlue),
                    ],
                  ),
                )),
                const SizedBox(height: 32),
                
                // Admin Details Section
                Text(
                  AppText.adminDetails,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSlate,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),

                _buildLabel(AppText.fullName),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.fullNameController,
                  hint: AppText.hintAdminName,
                ),
                const SizedBox(height: 20),

                _buildLabel(AppText.workEmail),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: controller.emailController,
                  hint: AppText.hintAdminEmail,
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.infoBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBAE6FD)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_rounded, color: AppColors.primaryBlue, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppText.adminCredentialsInfo,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSlate,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Secure SSL Label
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_rounded, color: AppColors.borderLight, size: 14),
                      const SizedBox(width: 6),
                       Text(
                        AppText.secureSSL,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.borderLight,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Create Button
                Obx(() => PrimaryButton(
                  text: AppText.createOrganizationAction,
                  onPressed: controller.createOrganization,
                  isLoading: controller.isLoading,
                )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep(int step, String label, {required bool isActive}) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primaryBlue : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primaryBlue : AppColors.borderLight,
            ),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? Colors.white : AppColors.borderLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? AppColors.textDark : AppColors.textLight,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.bodyMedium.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.hintText,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
      ),
    );
  }
}
