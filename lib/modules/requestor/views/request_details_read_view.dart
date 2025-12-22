import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';

class RequestDetailsReadView extends StatelessWidget {
  const RequestDetailsReadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> request = Get.arguments ?? {};
    final String status = request['status'] ?? AppText.statusPending;
    
    // Status color logic
    Color statusColor;
    Color statusBg;
    if (status == 'Approved') {
      statusColor = const Color(0xFF15803D);
      statusBg = const Color(0xFFDCFCE7);
    } else if (status == 'Rejected') {
      statusColor = const Color(0xFFB91C1C);
      statusBg = const Color(0xFFFEE2E2);
    } else {
      statusColor = const Color(0xFFB45309);
      statusBg = const Color(0xFFFEF3C7);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppText.requestDetails, style: TextStyle(color: AppTextStyles.h3.color, fontWeight: FontWeight.w700)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppTextStyles.h3.color),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Header Card
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.symmetric(vertical: 32),
                 decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24)),
                 child: Column(
                   children: [
                     Text(request['title'] ?? 'Request', style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                     const SizedBox(height: 8),
                     Text('₹${(request['amount'] as double? ?? 0.0).toStringAsFixed(2)}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: AppTextStyles.h1.color)),
                     const SizedBox(height: 16),
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                       decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                       child: Text(status, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: statusColor)),
                     )
                   ],
                 ),
               ),
               const SizedBox(height: 24),

               // Details Card
               Container(
                 padding: const EdgeInsets.all(24),
                 decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24)),
                 child: Column(
                   children: [
                     _buildDetailRow(Icons.category, AppText.category, request['category'] ?? 'N/A'),
                     const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
                     _buildDetailRow(Icons.calendar_today, AppText.date, request['date'] ?? 'N/A'),
                   ],
                 ),
               ),
               const SizedBox(height: 24),

               // Description
               Text(AppText.description, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTextStyles.h3.color)),
               const SizedBox(height: 12),
               Container(
                 width: double.infinity,
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
                 child: Text(
                   request['description'] ?? AppText.noDescription,
                   style: TextStyle(fontSize: 14, color: AppTextStyles.bodyMedium.color, height: 1.5),
                 ),
               ),
               const SizedBox(height: 24),

               // Attachments
               Text(AppText.attachments, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTextStyles.h3.color)),
               const SizedBox(height: 12),
               if (request['attachments'] != null && (request['attachments'] as List).isNotEmpty)
                 ListView.separated(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: (request['attachments'] as List).length,
                   separatorBuilder: (_, __) => const SizedBox(height: 12),
                   itemBuilder: (context, index) {
                     final file = (request['attachments'] as List)[index];
                     bool isImage = file['type'] == 'image';
                     return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: isImage ? const Color(0xFFE0F2FE) : const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                              child: Icon(isImage ? Icons.image : Icons.receipt, color: isImage ? const Color(0xFF0EA5E9) : const Color(0xFF15803D)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(file['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTextStyles.h3.color)),
                                  const SizedBox(height: 2),
                                  Text(file['size'], style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                ],
                              ),
                            ),
                            const Icon(Icons.download_rounded, color: Color(0xFF64748B)),
                          ],
                        ),
                     );
                   },
                 )
               else
                 Container(
                   width: double.infinity,
                   padding: const EdgeInsets.all(20),
                   decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20)),
                   child: Text(AppText.noAttachments, style: const TextStyle(color: Colors.grey)),
                 ),
               const SizedBox(height: 40),
             ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        const Spacer(),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTextStyles.h3.color)),
      ],
    );
  }
}
