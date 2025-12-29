import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../controllers/admin_user_controller.dart';
import '../widgets/admin_app_bar.dart';

class AdminAddUserView extends GetView<AdminUserController> {
  const AdminAddUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(title: AppText.addNewUserTitle),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(24),
      //   child: PrimaryButton(
      //     text: AppText.createUser,
      //     onPressed: () {
      //       if (formKey.currentState!.validate()) {
      //         controller.addUser(); // Should accept form data
      //       }
      //     },
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.backgroundAlt,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildLabel('First Name'),
              TextFormField(
                controller: controller.firstNameController,
                decoration: _inputDecoration(context, 'Enter first name'),
              ),
              const SizedBox(height: 16),

              _buildLabel('Last Name'),
              TextFormField(
                controller: controller.lastNameController,
                decoration: _inputDecoration(context, 'Enter last name'),
              ),
              const SizedBox(height: 16),

              _buildLabel(AppText.emailAddress),
              TextFormField(
                controller: controller.emailController,
                decoration: _inputDecoration(
                  context,
                  'ex: sarah@company.com',
                  icon: Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _buildLabel(AppText.phone),
              TextFormField(
                controller: controller.phoneController,
                decoration: _inputDecoration(
                  context,
                  '+1 (555) 000-0000',
                  icon: Icons.phone_outlined,
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildLabel(AppText.role),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Theme.of(context).cardColor,
                      value: controller.selectedRole.value.isEmpty
                          ? null
                          : controller.selectedRole.value,
                      hint: Text(
                        AppText.selectRole,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSlate,
                      ),
                      items: ['Requestor', 'Accountant'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (v) => controller.selectedRole.value = v ?? '',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),
              PrimaryButton(
                text: AppText.createUser,
                onPressed: controller.createUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text, style: AppTextStyles.h3.copyWith(fontSize: 14)),
    );
  }

  InputDecoration _inputDecoration(
    BuildContext context,
    String hint, {
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Theme.of(context).dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.primaryBlue),
      ),
      suffixIcon: icon != null
          ? Icon(icon, color: AppColors.textSlate, size: 20)
          : null,
    );
  }
}
