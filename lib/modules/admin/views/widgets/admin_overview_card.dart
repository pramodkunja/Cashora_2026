import 'package:flutter/material.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';

class AdminOverviewCard extends StatelessWidget {
  final String title;
  final String count;
  final bool isMoney;

  const AdminOverviewCard({
    Key? key,
    required this.title,
    required this.count,
    required this.isMoney,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppTextStyles.bodySmall.color),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: AppTextStyles.h1.copyWith(
              color: isMoney ? AppColors.primaryBlue : AppTextStyles.h1.color,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
