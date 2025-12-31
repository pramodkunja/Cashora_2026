import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/provide_clarification_controller.dart';

class ProvideClarificationView extends GetView<ProvideClarificationController> {
  const ProvideClarificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light grey bg
      appBar: AppBar(
        title: Text("Provide Clarification", style: AppTextStyles.h3.copyWith(fontSize: 18, color: Colors.blueAccent)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(() => _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
      final request = controller.request;
      // Determine if we need to show the input field
      // Logic: If status is 'clarification_required' OR 'clarification_requested', show input.
      // If 'clarification_responded' or 'pending_approval', hide input.
      final status = request['status'] as String? ?? '';
      final isPendingMyResponse = status == 'clarification_required' || status == 'clarification_requested';
      
      return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Status Banner
                  Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: !isPendingMyResponse 
                              ? const Color(0xFFECFDF5) // Green bg (Responded)
                              : const Color(0xFFFFF7ED), // Orange bg (Action Needed)
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: !isPendingMyResponse 
                                  ? const Color(0xFFD1FAE5) 
                                  : const Color(0xFFFFEDD5)
                          ),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: !isPendingMyResponse 
                                          ? const Color(0xFF10B981) 
                                          : const Color(0xFFF97316),
                                      shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                      !isPendingMyResponse 
                                          ? Icons.check 
                                          : Icons.priority_high_rounded, 
                                      size: 16, 
                                      color: Colors.white
                                  ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                              !isPendingMyResponse 
                                                  ? "Response Sent" 
                                                  : "Action Required",
                                              style: AppTextStyles.h3.copyWith(
                                                  fontSize: 16, 
                                                  color: !isPendingMyResponse 
                                                      ? const Color(0xFF065F46) 
                                                      : const Color(0xFF9A3412)
                                              )
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              !isPendingMyResponse 
                                                  ? "You have submitted the clarification. Waiting for approval." 
                                                  : "The approver has requested clarification on this request.",
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                  color: !isPendingMyResponse 
                                                      ? const Color(0xFF047857) 
                                                      : const Color(0xFFC2410C)
                                              )
                                          ),
                                      ],
                                  ),
                              ),
                          ],
                      ),
                  ),

                  Text("Request Details", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildRequestDetailCard(context),
                  const SizedBox(height: 24),
                  
                  Text("Clarification History", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  
                   Container(
                      decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Color(0xFFE2E8F0), width: 2)),
                      ),
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.only(left: 24),
                      child: _buildConversationHistory(context),
                  ),

                  if (isPendingMyResponse) ...[
                      const SizedBox(height: 32),
                      Text("Your Response", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                      const SizedBox(height: 12),
                      Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.borderLight),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
                              ]
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  TextFormField(
                                      controller: controller.responseController,
                                      maxLines: 5,
                                      style: AppTextStyles.bodyMedium,
                                      decoration: InputDecoration(
                                          hintText: "Type your explanation here...",
                                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate.withOpacity(0.7)),
                                          border: InputBorder.none,
                                      ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 56, // Hard explicit height constraint
                                      child: PrimaryButton(
                                          text: "Submit Response",
                                          onPressed: controller.submitClarification,
                                          isLoading: controller.isLoading.value,
                                          icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                      ),
                                  ),
                              ],
                          ),
                      ),
                  ]
              ]
          )
      );
  }

  Widget _buildRequestDetailCard(BuildContext context) {
      final request = controller.request;
      // Robust name mapping - Try deeper fallbacks
      String userName = 'Unknown User';
      if (request['employee_name'] != null) userName = request['employee_name'];
      else if (request['created_by_name'] != null) userName = request['created_by_name'];
      else if (request['user'] != null) {
          if (request['user'] is String) userName = request['user'];
          else if (request['user'] is Map && request['user']['name'] != null) userName = request['user']['name'];
      }
      else if (request['requestor_name'] != null) userName = request['requestor_name'];

      final String category = request['category'] ?? request['title'] ?? 'General Expense';
      final String amount = request['amount']?.toString() ?? '0.00';
      final String? receiptUrl = request['receipt_url'];

      return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
               boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
          ),
          child: Row(
              children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text(userName, style: AppTextStyles.h3.copyWith(fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(category, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
                               const SizedBox(height: 16),
                               Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                   decoration: BoxDecoration(
                                       color: const Color(0xFFE0F2FE),
                                       borderRadius: BorderRadius.circular(20),
                                   ),
                                   child: Text("₹$amount", style: AppTextStyles.h3.copyWith(fontSize: 14, color: const Color(0xFF0EA5E9), fontWeight: FontWeight.bold)),
                               ),
                          ],
                      ),
                  ),
                  // Bill Image
                  Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9), 
                          borderRadius: BorderRadius.circular(16),
                          image: receiptUrl != null && receiptUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(receiptUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                      ),
                      child: receiptUrl == null || receiptUrl.isEmpty 
                          ? const Icon(Icons.receipt_long_rounded, color: AppColors.textSlate) 
                          : null,
                  ),
              ],
          ),
      );
  }

  Widget _buildConversationHistory(BuildContext context) {
    final clarifications = controller.request['clarifications'] as List? ?? [];
    
    // Fallback: If no clarifications list but there is a 'comments' or 'admin_remarks' field, treat it as the first question?
    // User logic in ref view: if clarifications empty, check top level.
    // However, backend should send clarifications list. We will stick to list for now to match Admin view structure.
    
    if (clarifications.isEmpty) {
        // If empty, checking top level 'comments' just in case legacy data
        final adminComment = controller.request['admin_remarks'] ?? controller.request['comments'];
        if (adminComment != null && adminComment.toString().isNotEmpty) {
           return _buildTimelineItem(
               question: adminComment, 
               response: '', 
               askedAt: 'Recently', 
               respondedAt: '',
               approverName: "Approver" // We don't have approver name in top level usually
           );
        }
        return const SizedBox.shrink();
    }

    return Column(
        children: List.generate(clarifications.length, (index) {
          final item = clarifications[index];
          final String question = item['question'] ?? '';
          final String response = item['response'] ?? '';
          final String askedAt = _formatDate(item['asked_at']?.toString() ?? '');
          final String respondedAt = _formatDate(item['responded_at']?.toString() ?? '');
          
          return _buildTimelineItem(
              question: question,
              response: response,
              askedAt: askedAt,
              respondedAt: respondedAt,
              approverName: "Approver" // Ideally fetch from item['approver_name'] if available
          );
        }),
    );
  }

  Widget _buildTimelineItem({
      required String question, 
      required String response, 
      required String askedAt, 
      required String respondedAt,
      required String approverName
  }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Admin Question Node (Approver)
          if (question.isNotEmpty)
              Stack(
                  clipBehavior: Clip.none,
                  children: [
                      Positioned(
                          left: -31, // Align with left border
                          top: 0,
                          child: Container(
                              width: 14, 
                              height: 14,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFF97316), // Orange for Admin Question
                                  shape: BoxShape.circle,
                              ),
                          ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFF7ED), // Orange tinge
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFEDD5)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                      children: [
                                          Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFFFE4C4),
                                                  shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.person, size: 14, color: Color(0xFFEA580C)),
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
                          left: -31, // Align with left border
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Row(
                                      children: [
                                          Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFDCFCE7),
                                                  shape: BoxShape.circle,
                                              ),
                                              child: const Icon(Icons.face, size: 14, color: Color(0xFF15803D)),
                                          ),
                                          const SizedBox(width: 8),
                                          Text("You", style: AppTextStyles.h3.copyWith(fontSize: 14)),
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

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'Recently';
    try {
      final dt = DateTime.parse(dateStr);
      return "${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return 'Recently';
    }
  }
}
