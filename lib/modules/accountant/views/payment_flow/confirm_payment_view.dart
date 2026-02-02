import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../controllers/payment_flow_controller.dart';

class ConfirmPaymentView extends GetView<PaymentFlowController> {
  const ConfirmPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Confirm Payment', style: AppTextStyles.h3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Display
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryBlue.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Payment Amount',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '₹${controller.finalAmount.value.toStringAsFixed(2)}',
                          style: AppTextStyles.h1.copyWith(
                            color: Colors.white,
                            fontSize: 36.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Payment Method Selection
                  Text(
                    'Select Payment Method',
                    style: AppTextStyles.h3,
                  ),
                  SizedBox(height: 16.h),

                  Obx(() => Column(
                        children: [
                          _buildPaymentMethodTile(
                            title: 'UPI Payment',
                            subtitle: 'Pay using UPI ID',
                            icon: Icons.account_balance_wallet,
                            value: 'VPA',
                            groupValue: controller.selectedPaymentMethod.value,
                            onChanged: (value) {
                              controller.selectedPaymentMethod.value = value!;
                            },
                          ),
                          SizedBox(height: 12.h),
                          _buildPaymentMethodTile(
                            title: 'Bank Transfer',
                            subtitle: 'Pay using bank account',
                            icon: Icons.account_balance,
                            value: 'BANK_ACCOUNT',
                            groupValue: controller.selectedPaymentMethod.value,
                            onChanged: (value) {
                              controller.selectedPaymentMethod.value = value!;
                            },
                          ),
                        ],
                      )),

                  SizedBox(height: 32.h),

                  // Payment Details Form
                  Obx(() {
                    if (controller.selectedPaymentMethod.value == 'VPA') {
                      return _buildVPAForm();
                    } else {
                      return _buildBankAccountForm();
                    }
                  }),

                  SizedBox(height: 24.h),

                  // Mobile Number (Required for both)
                  Text('Mobile Number *', style: AppTextStyles.bodyLarge),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter 10-digit mobile number',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Remarks (Optional)
                  Text('Remarks (Optional)', style: AppTextStyles.bodyLarge),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: controller.remarksController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: 'Add payment remarks',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Initiate Payment Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => controller.startPhonePePayment(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Initiate Payment',
                        style: AppTextStyles.buttonText.copyWith(
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Info Text
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.infoBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            'Payment will be processed through PhonePe. You will be notified once the payment is complete.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Widget _buildPaymentMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : Colors.white,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: AppColors.primaryBlue,
            ),
            SizedBox(width: 12.w),
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : Colors.grey[600],
              size: 28.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryBlue : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVPAForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UPI ID *', style: AppTextStyles.bodyLarge),
        SizedBox(height: 8.h),
        Obx(() => TextField(
              controller: controller.vpaController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                if (value.contains('@')) {
                  controller.validateVPA(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'e.g., user@paytm',
                prefixIcon: const Icon(Icons.account_balance_wallet),
                suffixIcon: controller.isValidatingVpa.value
                    ? Padding(
                        padding: EdgeInsets.all(12.w),
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : controller.isVpaValid.value
                        ? Icon(Icons.check_circle, color: Colors.green, size: 24.sp)
                        : controller.vpaValidationMessage.value.isNotEmpty
                            ? Icon(Icons.error, color: Colors.red, size: 24.sp)
                            : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: controller.isVpaValid.value
                        ? Colors.green
                        : controller.vpaValidationMessage.value.isNotEmpty
                            ? Colors.red
                            : Colors.grey[300]!,
                  ),
                ),
              ),
            )),
        SizedBox(height: 8.h),
        Obx(() {
          if (controller.vpaValidationMessage.value.isNotEmpty) {
            return Row(
              children: [
                Icon(
                  controller.isVpaValid.value ? Icons.check_circle : Icons.error,
                  color: controller.isVpaValid.value ? Colors.green : Colors.red,
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  controller.vpaValidationMessage.value,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: controller.isVpaValid.value ? Colors.green : Colors.red,
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
        SizedBox(height: 8.h),
        Obx(() {
          if (controller.vpaAccountHolderName.value.isNotEmpty) {
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.green, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Account Holder: ${controller.vpaAccountHolderName.value}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildBankAccountForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Account Holder Name *', style: AppTextStyles.bodyLarge),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.accountHolderController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Enter account holder name',
            prefixIcon: const Icon(Icons.person),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        Text('Account Number *', style: AppTextStyles.bodyLarge),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.accountNumberController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Enter account number',
            prefixIcon: const Icon(Icons.account_balance),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),

        Text('IFSC Code *', style: AppTextStyles.bodyLarge),
        SizedBox(height: 8.h),
        TextField(
          controller: controller.ifscController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            LengthLimitingTextInputFormatter(11),
          ],
          decoration: InputDecoration(
            hintText: 'e.g., SBIN0001234',
            prefixIcon: const Icon(Icons.code),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
