import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../utils/widgets/buttons/primary_button.dart';
import '../../controllers/admin_user_controller.dart';
import '../widgets/admin_app_bar.dart';

class AdminDeactivateUserView extends GetView<AdminUserController> {
  const AdminDeactivateUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AdminAppBar(title: AppText.confirmation),
      body: SingleChildScrollView(
         padding: const EdgeInsets.all(24),
         child: Column(
           children: [
             const SizedBox(height: 20),
             // Big Icon
             Container(
               padding: const EdgeInsets.all(30),
               decoration: BoxDecoration(
                 color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF0C4A6E) // Dark blue
                    : const Color(0xFFE0F2FE),
                 shape: BoxShape.circle,
               ),
               child: Stack(
                 alignment: Alignment.bottomRight,
                 children: [
                   const Icon(Icons.person_off, size: 60, color: Colors.lightBlue),
                   const Icon(Icons.warning_amber_rounded, size: 30, color: Colors.orange),
                 ],
               ),
             ),
             const SizedBox(height: 24),
             Text(AppText.deactivateAccount, style: AppTextStyles.h2, textAlign: TextAlign.center),
             const SizedBox(height: 16),
             Text(AppText.deactivateDesc, 
               style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSlate), textAlign: TextAlign.center),
             
             const SizedBox(height: 32),
             
             // User Card
             Container(
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: Theme.of(context).cardColor, 
                 borderRadius: BorderRadius.circular(20),
                 boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
                 ],
               ),
               child: Row(
                 children: [
                   const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah')),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('Sarah Jenkins', style: AppTextStyles.h3),
                         Text('Finance Associate', style: AppTextStyles.bodyMedium.copyWith(color: Colors.lightBlue)),
                       ],
                     ),
                   ),
                   Container(
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.red.withOpacity(0.1), 
                       shape: BoxShape.circle
                     ),
                     child: const Icon(Icons.lock, color: Colors.red, size: 20),
                   )
                 ],
               ),
             ),
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(AppText.employeeId, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.textSlate)),
                   Row(
                     children: [
                       Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                       const SizedBox(width: 4),
                       Text(AppText.active, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: Colors.green)),
                     ],
                   )
                 ],
               ),
             ),
             
             const SizedBox(height: 32),
             
             // Checkbox
             Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Checkbox(value: false, onChanged: (v) {}),
                 Expanded(
                   child: Text(AppText.understandAction, style: AppTextStyles.bodyMedium),
                 ),
               ],
             ),
             
             const SizedBox(height: 40),
             
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: controller.deactivateUser,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF88DCF6), // Light blue from image
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                   elevation: 0,
                 ),
                 child: Text(AppText.deactivateUser, style: AppTextStyles.buttonText.copyWith(color: Colors.white)),
               ),
             ),
             const SizedBox(height: 16),
             TextButton(
               onPressed: () => Get.back(),
               child: Text(AppText.cancel, style: AppTextStyles.buttonText.copyWith(color: AppColors.textSlate)),
             ),
           ],
         ),
      ),
    );
  }
}
