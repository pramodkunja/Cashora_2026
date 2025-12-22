import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../controllers/admin_user_controller.dart';
import '../widgets/admin_app_bar.dart';

class AdminEditUserView extends GetView<AdminUserController> {
  const AdminEditUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = controller.rxSelectedUser; // Reactive map or object
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(
        title: AppText.editUser, // 'Edit User'
        actions: [
          TextButton(
            onPressed: () => controller.confirmDeactivate(user.value),
            child: Text(AppText.delete, style: AppTextStyles.buttonText.copyWith(color: Colors.red)),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        color: Theme.of(context).cardColor,
        child: PrimaryButton(
          text: AppText.updateUser,
          onPressed: controller.updateUser,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Photo
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah'), // Mock
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(AppText.editPhoto, style: AppTextStyles.buttonText.copyWith(color: Colors.lightBlue)),
            const SizedBox(height: 32),

            // Form
            _buildReadOnlyField(context, AppText.fullName, 'Jane Doe'), // Using mock data directly for layout match
            const SizedBox(height: 16),
            _buildReadOnlyField(context, AppText.emailAddress, 'jane.doe@company.com', icon: Icons.email),
            const SizedBox(height: 16),
            _buildReadOnlyField(context, AppText.phone, '+1 (555) 000-0000', icon: Icons.phone),
            const SizedBox(height: 16),
            _buildReadOnlyField(context, AppText.role, 'Approver', icon: Icons.badge),
            
            const SizedBox(height: 32),
            Container(alignment: Alignment.centerLeft, child: Text(AppText.permissions, style: AppTextStyles.h3)),
            const SizedBox(height: 16),

            // Permissions Card
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Obx(() => SwitchListTile(
                    title: Text(AppText.activeStatus, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                    subtitle: Text(AppText.userCanAccessSystem, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 12)),
                    value: controller.rxIsActive.value, 
                    onChanged: (v) => controller.rxIsActive.value = v,
                    activeColor: Colors.lightBlue,
                  )),
                  const Divider(),
                  SwitchListTile(
                    title: Text(AppText.allowCashAdvances, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                    subtitle: Text(AppText.enablePettyCashRequests, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 12)),
                    value: false, 
                    onChanged: (v) {},
                    activeColor: Colors.lightBlue,
                  ),
                   const Divider(),
                  SwitchListTile(
                    title: Text(AppText.viewGlobalReports, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                    subtitle: Text(AppText.readOnlyAccess, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 12)),
                    value: true, 
                    onChanged: (v) {},
                    activeColor: Colors.lightBlue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value, {IconData? icon}) {
    // Using Container instead of TextField for 'Edit' view style in image (looks boxed)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4),
          child: Text(label, style: AppTextStyles.h3.copyWith(fontSize: 14)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
               if(icon != null) ...[Icon(icon, size: 20, color: Colors.blueGrey), const SizedBox(width: 12)],
               Expanded(child: Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark))),
            ],
          ),
        ),
      ],
    );
  }
}
