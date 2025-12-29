import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/app_colors.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppTextStyles.h3.color, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon Badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.infoBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_open_rounded, // or security
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Headings
              Text(
                AppText.otpVerification, // "OTP Verification"
                style: AppTextStyles.h2.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              Text(
                AppText.otpSentTo(controller.email), // Dynamic message
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, height: 1.5),
              ),
              const SizedBox(height: 48),

              // OTP Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOtpInput(context, index)),
              ),
              const SizedBox(height: 40),

              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.didntReceiveCode,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                  ),
                  Obx(() {
                    if (controller.canResend.value) {
                      return GestureDetector(
                        onTap: controller.resendCode,
                        child: Text(
                          AppText.resend,
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      );
                    } else {
                      return Text(
                        AppText.resend, 
                        style: GoogleFonts.inter(
                          color: const Color(0xFFCBD5E1),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      );
                    }
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() => Text(
                '${AppText.resendCodeIn} ${controller.formattedTime}',
                style: GoogleFonts.inter(
                  color: AppTextStyles.bodyMedium.color,
                  fontSize: 14,
                ),
              )),
              
              const SizedBox(height: 40),

              // Verify Button
              Obx(() => SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: controller.isLoading ? null : controller.verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppText.verify,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput(BuildContext context, int index) {
    return Container(
      width: 48, 
      height: 56, 
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCBD5E1).withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppTextStyles.h3.color,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => controller.onOtpDigitEntered(index, value),
        ),
      ),
    );
  }
}
