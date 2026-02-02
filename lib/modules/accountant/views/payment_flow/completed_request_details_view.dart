import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';

class CompletedRequestDetailsView extends StatelessWidget {
  const CompletedRequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Request #PC-2024-89',
          style: AppTextStyles.h3.copyWith(color: Colors.black),
        ), // Mock ID
        centerTitle: true,
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Status Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Color(0xFF16A34A),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppText.completed,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF16A34A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppText.totalPaidAmount,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSlate,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('\$150.00', style: AppTextStyles.h1),
                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[100]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDateColumn(AppText.requestDate, 'Oct 24, 2023'),
                      Container(height: 40, width: 1, color: Colors.grey[200]),
                      _buildDateColumn(
                        AppText.paymentDateLabel,
                        'Oct 25, 2023',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Request Info
            _buildSectionHeader(AppText.requestInformation, Icons.description),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow(AppText.requestor, 'Jane Doe', boldValue: true),
                  Divider(color: Colors.grey[100], height: 32),
                  _buildInfoRow(AppText.department, 'Finance', boldValue: true),
                  Divider(color: Colors.grey[100], height: 32),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppText.purpose,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSlate,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Office Supplies Restock for Q4 audit preparation including binders and ink.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey[100], height: 32),
                  _buildInfoRow(
                    AppText.category,
                    'Operational',
                    boldValue: true,
                  ),
                  Divider(color: Colors.grey[100], height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppText.referenceCode,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSlate,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'REF-001',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Details
            _buildSectionHeader(
              AppText.paymentDetails,
              Icons.payments_outlined,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppText.paymentSource,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSlate,
                            ),
                          ), // 'Payment Source'
                          Text(
                            'Petty Cash Fund A',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[100]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSimpleColumn(AppText.transactionId, 'TXN-8842-X'),
                      _buildSimpleColumn('Processed At', '10:00 AM'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Bill Attachment
            _buildSectionHeader(AppText.billAttachment, Icons.receipt),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.picture_as_pdf, color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INV-2023-001.pdf',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Scanned on Oct 24, 2023 • 2.4 MB',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSlate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_rounded,
                      color: AppColors.primaryBlue,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Audit Trail
            _buildSectionHeader(AppText.auditTrail, Icons.history),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  _buildTimelineItem(
                    title: AppText.paidByAccountsTeam,
                    subtitle:
                        '${AppText.fundsDisbursedFrom} Petty Cash Fund A.',
                    date: 'Oct 25, 2023 • 10:00 AM',
                    icon: Icons.payments,
                    iconBg: const Color(0xFFDCFCE7),
                    iconColor: const Color(0xFF16A34A),
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: AppText.approvedByManager,
                    subtitle: 'Approved by Sarah Smith (Regional Manager).',
                    date: 'Oct 24, 2023 • 02:30 PM',
                    icon: Icons.check,
                    iconBg: const Color(0xFFDBEAFE),
                    iconColor: AppColors.primaryBlue,
                    isLast: false,
                  ),
                  _buildTimelineItem(
                    title: AppText.requestSubmitted,
                    subtitle: '${AppText.requestSubmittedInit} Jane Doe.',
                    date: 'Oct 24, 2023 • 09:15 AM',
                    icon: Icons.send,
                    iconBg: const Color(0xFFF1F5F9), // Grey/Slate
                    iconColor: AppColors.textSlate,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Download Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide(color: Colors.grey[300] ?? Colors.grey.shade300),
                  backgroundColor: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppText.downloadAuditReport,
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDateColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryBlue),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.h3),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool boldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start, // Align to top
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate),
        ),
        const SizedBox(width: 8), // Spacing
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: boldValue
                ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSlate),
        ),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyMedium),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required String date,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[200])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSlate,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textSlate.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
