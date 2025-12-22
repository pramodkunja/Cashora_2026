import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../../../routes/app_routes.dart';

class ResetPasswordSuccessView extends StatelessWidget {
  const ResetPasswordSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 80, color: AppColors.successGreen),
            const SizedBox(height: 24),
            Text(AppText.passwordUpdatedSuccess, style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 48),
            PrimaryButton(
              text: AppText.backToLogin,
              onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
            ),
          ],
        ),
      ),
    );
  }
}
