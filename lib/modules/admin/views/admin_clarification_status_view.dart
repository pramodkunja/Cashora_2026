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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(
        title: AppText.clarificationStatusTitle,
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
            // If Asking Again, show different view or overlay? 
            // Design shows "Ask Clarification Again" as a separate screen title in the 3rd image.
            // But user said "not any navigation to pages".
            // So we'll redraw the body.
            if (controller.state.value == ClarificationState.askingAgain) {
                return _buildAskAgainBody(context);
            }
            return _buildStatusBody(context);
        }),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.state.value == ClarificationState.responded) {
           return Container(
             padding: const EdgeInsets.all(24),
             decoration: const BoxDecoration(
               color: Colors.white,
               boxShadow: [
                 BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))
               ]
             ),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 InkWell(
                   onTap: controller.startAskAgain,
                   child: Container(
                     padding: const EdgeInsets.symmetric(vertical: 16),
                     width: double.infinity,
                     decoration: BoxDecoration(
                       border: Border.all(color: AppColors.borderLight),
                       borderRadius: BorderRadius.circular(30),
                     ),
                     child: Center(
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                Icon(Icons.chat_bubble_outline_rounded, size: 20, color: Theme.of(context).textTheme.bodyLarge?.color),
                                SizedBox(width: 8),
                                Text("Ask Clarification Again", style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).textTheme.bodyLarge?.color)),
                            ]
                        )
                     ),
                   ),
                 ),
                 const SizedBox(height: 16),
                 Row(
                   children: [
                     Expanded(
                       child: InkWell(
                        onTap: controller.reject,
                         child: Container(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           decoration: BoxDecoration(
                             color: const Color(0xFFFEE2E2), // Red bg
                             borderRadius: BorderRadius.circular(30),
                           ),
                           child: const Center(child: Text("Reject", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)))),
                         ),
                       ),
                     ),
                     const SizedBox(width: 16),
                     Expanded(
                       child: InkWell(
                         onTap: controller.approve,
                         child: Container(
                           padding: const EdgeInsets.symmetric(vertical: 16),
                           decoration: BoxDecoration(
                             color: AppColors.primaryBlue,
                             borderRadius: BorderRadius.circular(30),
                           ),
                           child: const Center(child: Text("Approve", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                         ),
                       ),
                     ),
                   ],
                 ),
               ],
             ),
           );
        } else if (controller.state.value == ClarificationState.askingAgain) {
            return Container(
                padding: const EdgeInsets.all(24),
                child: PrimaryButton(
                    text: AppText.sendClarificationRequest,
                    onPressed: controller.submitAskAgain,
                ),
            );
        }
        return const SizedBox.shrink(); 
      }),
    );
  }
  
  Widget _buildStatusBody(BuildContext context) {
      return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // For Demo: Invisible trigger to switch states
                  GestureDetector(
                      onTap: controller.toggleSimulateResponse,
                      child: Text(AppText.currentStatus, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  ),
                  const SizedBox(height: 12),
                  
                  // Status Banner
                  Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: controller.state.value == ClarificationState.responded 
                              ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF064E3B).withOpacity(0.5) : const Color(0xFFECFDF5)) // Greenish
                              : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF7C2D12).withOpacity(0.5) : const Color(0xFFFFF7ED)), // Orange
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                             color: controller.state.value == ClarificationState.responded 
                              ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF065F46) : const Color(0xFF10B981).withOpacity(0.2))
                              : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF9A3412) : const Color(0xFFF97316).withOpacity(0.2))
                          ),
                      ),
                      child: Row(
                          children: [
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: controller.state.value == ClarificationState.responded 
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFFEDD5),
                                      shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                      controller.state.value == ClarificationState.responded ? Icons.mark_email_read_rounded : Icons.pending_actions_rounded,
                                      color: controller.state.value == ClarificationState.responded ? const Color(0xFF10B981) : const Color(0xFFF97316),
                                  ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                              controller.state.value == ClarificationState.responded ? AppText.responseReceived : AppText.pendingResponse,
                                              style: AppTextStyles.h3.copyWith(
                                                  fontSize: 16,
                                                  color: controller.state.value == ClarificationState.responded ? const Color(0xFF065F46) : const Color(0xFF9A3412),
                                              ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                              controller.state.value == ClarificationState.responded ? AppText.reviewResponseAction : AppText.waitingForRequestor,
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                  color: controller.state.value == ClarificationState.responded ? const Color(0xFF064E3B) : const Color(0xFFC2410C),
                                              ),
                                          ),
                                      ],
                                  ),
                              ),
                          ],
                      ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text("Request Details", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildRequestDetailCard(context),
                  const SizedBox(height: 24),
                  
                  Text(AppText.yourClarificationRequest, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildMessageCard(
                      context: context,
                      icon: Icons.person,
                      title: "SENT BY YOU • 2 HRS AGO",
                      message: "Please provide the itemized receipt for the office supplies. The current attachment only shows the credit card transaction slip.",
                      isRequestor: false,
                  ),
                  
                  const SizedBox(height: 24),
                  Text(AppText.requestorsResponse, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  
                  if (controller.state.value == ClarificationState.pending)
                    Container(
                        padding: const EdgeInsets.all(32),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: AppColors.borderLight, style: BorderStyle.none), // Dashed border implementation needed or simple box
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                        ),
                        // Dashed border simulation with CustomPaint or DottedBorder package is better, 
                        // but for standard flutter without packages:
                        child: Column(
                            children: [
                                const Icon(Icons.mail_outline_rounded, size: 48, color: AppColors.textSlate),
                                const SizedBox(height: 16),
                                Text(AppText.waitingForResponsePlaceholder, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
                            ],
                        ),
                    )
                  else
                    _buildResponseCard(context),
              ],
          ),
      );
  }
  
  Widget _buildAskAgainBody(BuildContext context) {
      // Replicates the "Ask Clarification Again" screen from image
      return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Text("Request Details", style: AppTextStyles.h3.copyWith(fontSize: 16)),
                   const SizedBox(height: 12),
                   _buildRequestDetailCard(context),
                   const SizedBox(height: 24),
                   
                   Text(AppText.clarificationHistory, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                   const SizedBox(height: 12),
                  _buildMessageTab(
                      context: context,
                      title: "YOU ASKED • 2 DAYS AGO",
                      message: "Please provide the itemized receipt...",
                      isBlue: false,
                  ),
                  const SizedBox(height: 12),
                  _buildMessageTab(
                      context: context,
                      title: "John Doe • Response Received • 2 hrs ago",
                      message: "I have uploaded the new receipt image as requested...",
                      isBlue: true,
                  ),
                  
                  const SizedBox(height: 24),
                  Text(AppText.furtherClarificationNeeded, style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              TextFormField(
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                      hintText: AppText.explainWhy,
                                      hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate),
                                      border: InputBorder.none,
                                  ),
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(AppText.makeItClear, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                              )
                          ],
                      ),
                  ),
              ]
          )
      );
  }

  Widget _buildRequestDetailCard(BuildContext context) {
      // Reusing logic from history card roughly
      return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
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
                              Text(controller.request['user'] ?? "John Doe", style: AppTextStyles.h3.copyWith(fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(controller.request['title'] ?? "Office Supplies", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate)),
                               const SizedBox(height: 16),
                               Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                   decoration: BoxDecoration(
                                       color: const Color(0xFFE0F2FE),
                                       borderRadius: BorderRadius.circular(20),
                                   ),
                                   child: Text("\$${controller.request['amount'] ?? '50.00'}", style: AppTextStyles.h3.copyWith(fontSize: 14, color: AppColors.primaryBlue)),
                               ),
                          ],
                      ),
                  ),
                  // Bill Image
                  Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xFFEAB308), // Placeholder color from image
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                              image: NetworkImage('https://via.placeholder.com/150'), // Placeholder
                              fit: BoxFit.cover,
                          )
                      ),
                  ),
              ],
          ),
      );
  }

  Widget _buildMessageCard({required BuildContext context, required IconData icon, required String title, required String message, required bool isRequestor}) {
      return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Row(
                      children: [
                          Container(
                              padding: const EdgeInsets.all(6),
                               decoration: BoxDecoration(
                                   color: isRequestor ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                                   shape: BoxShape.circle,
                               ),
                               child: Icon(icon, size: 16, color: isRequestor ? const Color(0xFF16A34A) : const Color(0xFF2563EB)),
                          ),
                          const SizedBox(width: 12),
                          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSlate)),
                      ],
                  ),
                  const SizedBox(height: 12),
                  Text(message, style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
                  
              ],
          ),
      );
  }
  
  Widget _buildResponseCard(BuildContext context) {
      return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDCFCE7)),
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
                               child: const Icon(Icons.reply, size: 16, color: Color(0xFF16A34A)),
                          ),
                           const SizedBox(width: 12),
                          Text("JOHN DOE • 2 HRS AGO", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSlate)),
                      ],
                  ),
                   const SizedBox(height: 12),
                   Text("Hi, sorry about that! I've attached the full itemized receipt here.", style: AppTextStyles.bodyMedium.copyWith(height: 1.5)),
                   const SizedBox(height: 16),
                   Container(
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                           color: Theme.of(context).cardColor,
                           borderRadius: BorderRadius.circular(16),
                           border: Border.all(color: AppColors.borderLight),
                       ),
                       child: Row(
                           children: [
                               Container(
                                   padding: const EdgeInsets.all(8),
                                   decoration: BoxDecoration(
                                       color: const Color(0xFFF1F5F9),
                                       borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: const Icon(Icons.picture_as_pdf, color: AppColors.textSlate),
                               ),
                               const SizedBox(width: 12),
                               Expanded(
                                   child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                           Text(AppText.itemizedReceipt, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                           const SizedBox(height: 2),
                                            Text("1.2 MB", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                                       ],
                                   ),
                               ),
                               Text("View", style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                           ],
                       ),
                   )
              ],
          ),
      );
  }
  
  Widget _buildMessageTab({required BuildContext context, required String title, required String message, required bool isBlue}) {
      return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
           decoration: BoxDecoration(
              color: isBlue ? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E3A8A).withOpacity(0.5) : const Color(0xFFEFF6FF)) : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              border: isBlue ? Border.all(color: const Color(0xFFDBEAFE)) : null,
              boxShadow: isBlue ? [] : [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Text(title.toUpperCase(), style: AppTextStyles.bodyMedium.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: isBlue ? AppColors.primaryBlue : AppColors.textSlate)),
                   const SizedBox(height: 8),
                   Text(message, style: AppTextStyles.bodyMedium.copyWith(height: 1.4)),
              ],
          ),
      );
  }
}
