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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppText.forgotPasswordTitle, style: AppTextStyles.h3),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTextStyles.h3.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              AppText.forgotPasswordSubtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodyMedium.color),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: AppText.emailOrPhone,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).dividerColor)),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: AppText.sendCode,
              onPressed: controller.sendCode,
            ),
          ],
        ),
      ),
    );
  }
}
