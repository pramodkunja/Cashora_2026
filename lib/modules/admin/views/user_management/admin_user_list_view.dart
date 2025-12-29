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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppColors.textDark),
          ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppText.searchUsersHint,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSlate,
                        ),
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.search,
                          color: AppColors.textSlate,
                        ),
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
                  child: const Icon(
                    Icons.tune_rounded,
                    color: AppColors.textSlate,
                  ),
                ),
              ],
            ),
          ),

          // List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Obx(
              () => Row(
                children: [
                  Text(
                    'ALL USERS (${controller.rxUsers.length})',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppText.exportList,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // User List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingUsers.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.rxUsers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users found',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Users will appear here once added',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSlate,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: controller.fetchUsers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchUsers,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  itemCount: controller.rxUsers.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final user = controller.rxUsers[index];
                    return _buildUserCard(context, user);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 150,
        child: FloatingActionButton.extended(
          onPressed: controller.addUser,
          backgroundColor: AppColors.primaryBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          icon: const Icon(Icons.person_add, color: Colors.white, size: 20),
          label: Text(
            'Add User',
            style: AppTextStyles.buttonText.copyWith(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, Map<String, dynamic> user) {
    // Handle different field name variations
    String name =
        user['full_name'] ??
        user['name'] ??
        '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim();
    if (name.isEmpty) name = 'Unknown User';

    String role = user['role'] ?? 'Requestor';
    String email = user['email'] ?? 'No email';

    Color badgeBg = const Color(0xFFF1F5F9);
    Color badgeText = AppColors.textSlate;

    // Verify active status based on various key possibilities
    final bool isActive = user['isActive'] ?? user['is_active'] ?? true;

    // Badge Status Logic
    if (!isActive) {
      badgeBg = const Color(0xFFFEE2E2); // Light Red
      badgeText = Colors.red;
    } else if (role.toLowerCase() == 'accountant') {
      badgeBg = const Color(0xFFE0F2FE); // Light Cyan
      badgeText = AppColors.infoBlue;
    } else if (role.toLowerCase() == 'approver') {
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
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: badgeBg,
              child: Text(
                name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'U',
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
                      Flexible(
                        child: Text(
                          name,
                          style: AppTextStyles.h3.copyWith(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          !isActive
                              ? AppText.inactive.toUpperCase()
                              : role.toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSlate,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.borderLight,
            ),
          ],
        ),
      ),
    );
  }
}
