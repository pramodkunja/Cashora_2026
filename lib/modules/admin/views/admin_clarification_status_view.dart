import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../controllers/admin_clarification_status_controller.dart';
import 'widgets/admin_app_bar.dart';

class AdminClarificationStatusView extends GetView<AdminClarificationStatusController> {
  const AdminClarificationStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Light grey bg
      appBar: AdminAppBar(
        title: "Review Clarification",
        onBackPressed: () {
            if (controller.state.value == ClarificationState.askingAgain) {
                controller.state.value = ClarificationState.responded;
            } else {
                Get.back();
            }
        },
      ),
      body: SafeArea(
        child: Obx(() {
            if (controller.state.value == ClarificationState.askingAgain) {
                return _buildAskAgainBody(context);
            }
            return _buildStatusBody(context);
        }),
      ),
      bottomNavigationBar: Obx(() {
        Widget? bottomBar;
        if (controller.state.value == ClarificationState.responded) {
           bottomBar = Container(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             height: 110, // Explicit fixed height to prevent expansion
             decoration: const BoxDecoration(
               color: Colors.white,
               boxShadow: [
                 BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
               ]
             ),
             child: SafeArea(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Expanded(
                     child: InkWell(
                      onTap: controller.reject,
                       child: Container(
                         height: 56, // Fixed button height
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(30),
                           border: Border.all(color: const Color(0xFFEF4444)),
                         ),
                         child: const Center(child: Text("Reject", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)))),
                       ),
                     ),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: InkWell(
                       onTap: controller.approve,
                       child: Container(
                         height: 56, // Fixed button height
                         decoration: BoxDecoration(
                           color: const Color(0xFF0EA5E9), // Light Blue
                           borderRadius: BorderRadius.circular(30),
                         ),
                         child: const Center(child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.check, color: Colors.white, size: 20),
                             SizedBox(width: 8),
                             Text("Approve", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                           ],
                         )),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           );
        } else if (controller.state.value == ClarificationState.askingAgain) {
            bottomBar = Container(
                padding: const EdgeInsets.all(24),
                color: Colors.white,
                child: SafeArea(
                  child: PrimaryButton(
                      text: "Send Clarification Request",
                      onPressed: controller.submitAskAgain,
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
            );
        }
        
        return bottomBar ?? const SizedBox.shrink();
      }),
    );
  }
  
  Widget _buildStatusBody(BuildContext context) {
    try {
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
                          color: controller.state.value == ClarificationState.responded 
                              ? const Color(0xFFECFDF5) // Green bg
                              : const Color(0xFFFFF7ED), // Orange bg
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: controller.state.value == ClarificationState.responded 
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
                                      color: controller.state.value == ClarificationState.responded 
                                          ? const Color(0xFF10B981) 
                                          : const Color(0xFFF97316),
                                      shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                      controller.state.value == ClarificationState.responded 
                                          ? Icons.check 
                                          : Icons.hourglass_top_rounded, 
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
                                              controller.state.value == ClarificationState.responded 
                                                  ? "Response Received" 
                                                  : "Waiting for Response",
                                              style: AppTextStyles.h3.copyWith(
                                                  fontSize: 16, 
                                                  color: controller.state.value == ClarificationState.responded 
                                                      ? const Color(0xFF065F46) 
                                                      : const Color(0xFF9A3412)
                                              )
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              controller.state.value == ClarificationState.responded 
                                                  ? "Requestor has updated the details." 
                                                  : "This request is pending a response from the user.",
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                  color: controller.state.value == ClarificationState.responded 
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
              ],
          ),
      );
    } catch (e, stack) {
        print("ERROR rendering Admin Status Body: $e");
        print(stack);
        return Center(
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text("Error displaying request details.\n\n$e", style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            ),
        );
    }
  }
  
  Widget _buildAskAgainBody(BuildContext context) {
      return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Text("Request Details", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                   const SizedBox(height: 12),
                   _buildRequestDetailCard(context),
                   const SizedBox(height: 24),
                   
                   Text("Clarification History", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                   const SizedBox(height: 12),
                   _buildConversationHistory(context),
                  
                  const SizedBox(height: 24),
                  Text("Further Clarification Needed", style: AppTextStyles.h3.copyWith(fontSize: 16)),
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
                                  controller: controller.reasonController,
                                  maxLines: 5,
                                  style: AppTextStyles.bodyMedium,
                                  decoration: InputDecoration(
                                      hintText: "Explain why the response is still insufficient (e.g., 'The image is too blurry to read the date')...",
                                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate.withOpacity(0.7)),
                                      border: InputBorder.none,
                                  ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text("Make it clear", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                              )
                          ],
                      ),
                  ),
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
    // Parse clarifications list
    final clarifications = controller.request['clarifications'] as List? ?? [];
    
    if (clarifications.isEmpty) return const SizedBox.shrink();

    return Column(
        children: List.generate(clarifications.length, (index) {
          final item = clarifications[index];
          final String question = item['question'] ?? '';
          final String response = item['response'] ?? '';
          final String askedAt = _formatDate(item['asked_at']?.toString() ?? '');
          final String respondedAt = _formatDate(item['responded_at']?.toString() ?? '');
          
          final String requestorName = controller.request['employee_name'] ?? controller.request['user'] ?? 'Requestor';
          // Get initials
          String initials = "U";
          if (requestorName.isNotEmpty) {
               final parts = requestorName.trim().split(" ");
               if (parts.length > 1 && parts[1].isNotEmpty) {
                   initials = "${parts[0][0]}${parts[1][0]}".toUpperCase();
               } else {
                   initials = requestorName[0].toUpperCase();
               }
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Admin Question Node
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
                                                      color: Color(0xFFDBEAFE),
                                                      shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.person, size: 14, color: Color(0xFF2563EB)),
                                              ),
                                              const SizedBox(width: 8),
                                              Text("You (Approver)", style: AppTextStyles.h3.copyWith(fontSize: 14)),
                                              const Spacer(),
                                              Text(askedAt, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                                          ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(question, style: AppTextStyles.bodyMedium),
                                  ],
                              ),
                          ),
                      ],
                  ),
              
              // 2. Requestor Response Node
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
                                  color: const Color(0xFFF0FDF4), // Light green bg
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFBBF7D0)),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                      Row(
                                          children: [
                                              Container(
                                                  height: 28, width: 28,
                                                  decoration: const BoxDecoration(
                                                      color: Color(0xFFDCFCE7),
                                                      shape: BoxShape.circle,
                                                  ),
                                                  child: Center(child: Text(initials, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)))),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(requestorName, style: AppTextStyles.h3.copyWith(fontSize: 14)),
                                              const Spacer(),
                                              Text(respondedAt, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                                          ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(response, style: AppTextStyles.bodyMedium),
                                      
                                      // Attachment not available in backend response yet, hiding static block
                                  ],
                              ),
                          ),
                      ],
                  ),
            ],
          );
        }),
    );
  }
  
  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'Recently';
    try {
      final dt = DateTime.parse(dateStr);
      // minimalistic format
      return "${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return 'Recently';
    }
  }
}
