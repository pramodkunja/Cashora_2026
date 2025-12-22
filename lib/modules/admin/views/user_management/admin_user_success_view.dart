import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../../../routes/app_routes.dart';

class AdminUserSuccessView extends StatelessWidget {
  const AdminUserSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('DEBUG: AdminUserSuccessView arguments: ${Get.arguments}');
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final type = args['type'] ?? 'create'; // 'create', 'update', 'deactivate'
    
    // Mock user data for summary
    final String userName = 'Sarah Jenkins'; 
    final String userRole = 'Accountant';
    final String email = 'sarah@company.com';
    // final String phone = '(555) 123-4567';
    // final String createdDate = 'Oct 24, 2023'; 

    final bool isDeactivate = type == 'deactivate';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Success Icon with Glow
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.successGreen.withOpacity(0.1), blurRadius: 30, spreadRadius: 10),
                  ],
                ),
                child: Center(
                  child: Container(
                     padding: const EdgeInsets.all(24),
                     decoration: const BoxDecoration(
                       color: AppColors.successBg,
                       shape: BoxShape.circle,
                     ),
                     child: const Icon(Icons.check, color: AppColors.successGreen, size: 40),
                   ),
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                isDeactivate ? AppText.userDeactivatedSuccess : AppText.userCreatedSuccessTitle,
                 style: AppTextStyles.h2, textAlign: TextAlign.center
              ),
              const SizedBox(height: 12),
              
              if (isDeactivate)
                 RichText(
                   textAlign: TextAlign.center,
                   text: TextSpan(
                     text: userName,
                     style: AppTextStyles.h3.copyWith(fontSize: 14),
                     children: [
                       TextSpan(text: ' has been deactivated.\n', style: AppTextStyles.bodyMedium.copyWith(color: Colors.blueGrey)),
                       TextSpan(text: 'Their access to the petty cash system has been revoked.', style: AppTextStyles.bodyMedium.copyWith(color: Colors.blueGrey)),
                     ]
                   ),
                 )
              else
                 Text(AppText.userCreatedSuccessDesc, 
                   style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                   textAlign: TextAlign.center,
                 ),

              const SizedBox(height: 40),

              // Only show user summary card if not deactivating? Or show simplified?
              // Image for deactivation doesn't show the summary card, just text.
              // We will hide the summary card for deactivation to match the image provided.
              if (!isDeactivate)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal, 
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah'),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userName, style: AppTextStyles.h3),
                                const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(userRole, style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, color: AppColors.primaryBlue)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      _buildSummaryRow(Icons.email, AppText.emailAddress, email), 
                      const SizedBox(height: 16),
                      _buildSummaryRow(Icons.phone, AppText.phone, '(555) 123-4567'),
                      const SizedBox(height: 16),
                      _buildSummaryRow(Icons.calendar_today, AppText.createdOn, 'Oct 24, 2023'),
                    ],
                  ),
                ),

              const SizedBox(height: 40),

              PrimaryButton(
                text: AppText.goToManageUsers,
                onPressed: () => Get.offNamed(AppRoutes.ADMIN_USER_LIST),
                icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 16),
              
              if (!isDeactivate)
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Get.back(); 
                    },
                      style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withOpacity(0.05) 
                            : Colors.lightBlue.shade50,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.white.withOpacity(0.1) 
                              : Colors.lightBlue.shade200
                          ),
                        ),
                      ),
                    icon: const Icon(Icons.person_add, color: AppColors.primaryBlue),
                    label: Text(AppText.addAnotherUser, style: AppTextStyles.buttonText.copyWith(color: AppColors.primaryBlue)),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSlate), 
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
        const Spacer(),
        Text(value, style: AppTextStyles.h3.copyWith(fontSize: 14)), 
      ],
    );
  }
}
