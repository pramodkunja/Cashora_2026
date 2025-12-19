import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/common_search_bar.dart';
import '../controllers/monthly_spent_controller.dart';
import '../../../../utils/app_text.dart';

class MonthlySpentView extends GetView<MonthlySpentController> {
  const MonthlySpentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inject controller if not using Binding (simpler for now) or ensure binding is set up
    Get.put(MonthlySpentController()); 

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF0F172A)),
          onPressed: () => Get.back(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFF64748B)),
              onPressed: controller.previousMonth,
            ),
            GestureDetector(
              onTap: controller.selectMonthYear,
              child: Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent), // Touch target
                ),
                child: Row( // Row kept for structure or remove if only text needed
                  children: [
                    Text(
                      controller.currentMonth.value,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
              onPressed: controller.nextMonth,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: CommonSearchBar(
                controller: controller.searchController,
                hintText: AppText.searchTransactions,
                onChanged: controller.searchTransactions,
                // Removed onFilterTap to hide filter button
              ),
            ),
            
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  _buildFilterChip(0, AppText.filterAll),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, AppText.filterPaid),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, AppText.filterPending),
                  const SizedBox(width: 8),
                  _buildFilterChip(3, AppText.filterRejected),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Summary Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFF0F9FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                     BoxShadow(color: const Color(0xFFE0F2FE).withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    Text(AppText.totalSpent, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
                    const SizedBox(height: 8),
                    Obx(() => Text(
                      '₹${controller.totalSpent.value.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    )),
                    const SizedBox(height: 16),
                    Container(
                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                       decoration: BoxDecoration(
                         color: const Color(0xFFDCFCE7),
                         borderRadius: BorderRadius.circular(20),
                       ),
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           const Icon(Icons.trending_down, size: 16, color: Color(0xFF16A34A)),
                           const SizedBox(width: 4),
                           Obx(() => Text(
                             controller.comparisonText.value,
                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF16A34A)),
                           )),
                         ],
                       ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppText.monthlySpentTransactions,
                   style: TextStyle(
                     fontSize: 12, 
                     fontWeight: FontWeight.w700, 
                     color: const Color(0xFF94A3B8), 
                     letterSpacing: 1.1
                   ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Transaction List
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: controller.displayedTransactions.length,
                itemBuilder: (context, index) {
                  final item = controller.displayedTransactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      // Slight shadow if needed, but clean look is fine too
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, 
                          height: 48,
                          decoration: BoxDecoration(
                            color: item['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item['icon'], color: item['iconColor']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                              const SizedBox(height: 4),
                              Text(item['date'], style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text(item['amount'].toString().replaceAll('\$', '₹'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                             const SizedBox(height: 4),
                             _buildStatusBadge(item['status']),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
            
            // Bottom Bar Space if needed, but since we pushed this, maybe no bottom bar or use Scaffold bottomNavigationBar? 
            // Design shows bottom bar. Reusing existing one.
          ],
        ),
      ),
    );
  }

  // Simplified version of bottom bar just for visual matching if not interactive here, 
  // or we can import the actual RequestorBottomBar but it needs RequestorController.
  // The user asked to "keep the bottom bar which is existing one". 
  // Since this is a pushed view, typically bottom bar is hidden, but if they want it, we can fake it or reuse.
  // I will assume for now we don't need the interactive bottom bar on a details screen (sub-screen), 
  // but looking at image it HAS a bottom bar.
  // So I'll just rely on the main scaffold or add a static one.
  // Widget _buildBottomBarShim() {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       color: Colors.white,
  //       border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
  //     ),
  //     padding: const EdgeInsets.only(top: 16, bottom: 32),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //          Icon(Icons.home_outlined, color: Colors.grey[400]),
  //          Column(
  //            mainAxisSize: MainAxisSize.min,
  //            children: [
  //              Icon(Icons.receipt_long, color: Color(0xFF0EA5E9)),
  //              SizedBox(height: 4),
  //              Text('Requests', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF0EA5E9))),
  //              SizedBox(height: 2),
  //              Container(width: 4, height: 4, decoration: BoxDecoration(color: Color(0xFF0EA5E9), shape: BoxShape.circle))
  //            ],
  //          ),
  //          Icon(Icons.person_outline, color: Colors.grey[400]),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    if (status == 'Paid') {
      bg = const Color(0xFFE0F2FE); // Blue
      text = const Color(0xFF0EA5E9);
    } else if (status == 'Pending') {
      bg = const Color(0xFFFFF7ED); // Orange
      text = const Color(0xFFEA580C);
    } else {
      bg = const Color(0xFFFEE2E2); // Red
      text = const Color(0xFFDC2626);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        status, 
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: text)
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    return Obx(() {
      final isSelected = controller.selectedFilterIndex.value == index;
      return GestureDetector(
        onTap: () => controller.changeFilter(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            // border: isSelected ? null : Border.all(color: Colors.transparent),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
    });
  }
}
