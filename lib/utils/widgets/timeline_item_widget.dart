import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';

class TimelineItemWidget extends StatelessWidget {
  final String question;
  final String response;
  final String askedAt;
  final String respondedAt;
  final String approverName;

  const TimelineItemWidget({
    Key? key,
    required this.question,
    required this.response,
    required this.askedAt,
    required this.respondedAt,
    required this.approverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Admin Question Node
          if (question.isNotEmpty)
              Stack(
                  clipBehavior: Clip.none,
                  children: [
                      Positioned(
                          left: -31, 
                          top: 0,
                          child: Container(
                              width: 14, 
                              height: 14,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFE2E8F0), 
                                  shape: BoxShape.circle,
                              ),
                          ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white, 
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[200]!), 
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                      children: [
                                          Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xFFDBEAFE), 
                                                  shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.person, size: 14, color: Color(0xFF2563EB)), 
                                          ),
                                          const SizedBox(width: 8),
                                          Text(approverName, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                                          const Spacer(),
                                          Text(askedAt, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                                      ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(question, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark)),
                              ],
                          ),
                      ),
                  ],
              ),
          
          // 2. My Response Node
          if (response.isNotEmpty)
               Stack(
                  clipBehavior: Clip.none,
                  children: [
                      Positioned(
                          left: -31, 
                          top: 0,
                          child: Container(
                              width: 14, 
                              height: 14,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF10B981), // Green dot
                                  shape: BoxShape.circle,
                              ),
                          ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4), 
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFBBF7D0)), 
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                      children: [
                                          Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color: const Color(0xFFDCFCE7), 
                                                  shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.face, size: 14, color: Color(0xFF15803D)), 
                                          ),
                                          const SizedBox(width: 8),
                                          Text(AppText.you, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                                          const Spacer(),
                                          Text(respondedAt, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                                      ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(response, style: AppTextStyles.bodyMedium),
                              ],
                          ),
                      ),
                  ],
              ),
        ],
      );
  }
}
