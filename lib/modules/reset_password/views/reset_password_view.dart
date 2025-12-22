import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppText.resetPassword, style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTextStyles.h3.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              AppText.createNewPassword,
              style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodyMedium.color),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller.newPasswordController,
              decoration: InputDecoration(
                labelText: AppText.newPassword,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.confirmPasswordController,
              decoration: InputDecoration(
                labelText: AppText.confirmPassword,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).dividerColor)),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: AppText.updatePassword,
              onPressed: controller.resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
