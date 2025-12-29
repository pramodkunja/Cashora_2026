import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('Edit Profile', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Image Edit
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryLight, width: 4),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.backgroundLight,
                  child: Icon(Icons.person, size: 50, color: AppColors.textLight),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Form Fields
            _buildTextField(
              context,
              label: AppText.fullName,
              controller: controller.nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            
            _buildTextField(
              context,
              label: AppText.emailAddress,
              controller: controller.emailController, // Should be read-only logically
              icon: Icons.email_outlined,
              readOnly: true,
            ),
            const SizedBox(height: 20),
            
            _buildTextField(
              context,
              label: AppText.phone,
              controller: controller.phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
             const SizedBox(height: 20),
            
            _buildTextField(
              context,
              label: AppText.role,
              controller: controller.roleController, // Read-only
              icon: Icons.badge_outlined,
              readOnly: true,
            ),

            const SizedBox(height: 40),

            Obx(() => PrimaryButton(
              text: 'Save Changes',
              onPressed: controller.saveProfile,
              isLoading: controller.isSaving.value,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600, 
            color: AppTextStyles.bodyMedium.color
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLarge.copyWith(
            color: readOnly ? AppColors.textSlate : AppColors.textDark,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: readOnly ? AppColors.textSlate : AppColors.textLight),
            filled: true,
            fillColor: readOnly 
                ? AppColors.backgroundLight // or a specific read-only color
                : Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: readOnly ? Theme.of(context).dividerColor : AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
