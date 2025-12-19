import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';

class AdminBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSlate,
        selectedLabelStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: AppText.navHome,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            label: AppText.navApprovals,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: AppText.navHistory,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: AppText.navProfile,
          ),
        ],
      ),
    );
  }
}
