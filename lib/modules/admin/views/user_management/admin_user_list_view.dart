import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../controllers/admin_user_controller.dart';
import '../widgets/admin_app_bar.dart';

class AdminUserListView extends GetView<AdminUserController> {
  const AdminUserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(
        title: AppText.manageUsers,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_vert, color: AppColors.textDark))
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppText.searchUsersHint,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: AppColors.textSlate),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.textSlate),
                ),
              ],
            ),
          ),
          
          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text('ALL USERS (24)', style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                const Spacer(),
                Text(AppText.exportList, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: 16),

          // User List
          Expanded(
            child: Obx(() => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: controller.rxUsers.length,
              separatorBuilder: (c, i) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final user = controller.rxUsers[index];
                return _buildUserCard(context, user);
              },
            )),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton.extended(
          onPressed: controller.addUser,
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
          label: Text('Add User', style: AppTextStyles.buttonText.copyWith(color: Colors.white, fontSize: 14)),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    String role = user['role'] ?? 'Requestor';
    Color badgeBg = const Color(0xFFF1F5F9);
    Color badgeText = AppColors.textSlate;
    
    // Badge Status Logic
    if (role.toUpperCase() == 'ACCOUNTANT') {
      badgeBg = const Color(0xFFE0F2FE); // Light Cyan
      badgeText = AppColors.infoBlue;
    } else if (role.toUpperCase() == 'APPROVER') {
      badgeBg = const Color(0xFFF3E8FF); // Light Purple
      badgeText = const Color(0xFF9333EA); // Purple
    }

    return GestureDetector(
      onTap: () => controller.editUser(user),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: badgeBg, // Use badge color for avatar bg too? Or different? Image implies light colored avatars with initials
            child: Text(
               user['name'].substring(0, 2).toUpperCase(), 
               style: AppTextStyles.h3.copyWith(color: badgeText),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user['name'], style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(role.toUpperCase(), style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: badgeText)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(user['email'] ?? 'email@company.com', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.borderLight),
        ],
      ),
      ),
    );
  }
}
