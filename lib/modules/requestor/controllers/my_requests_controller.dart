import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class MyRequestsController extends GetxController {
  final currentTab = 0.obs; // 0: All, 1: Pending, 2: Approved, 3: Rejected
  
  // Mock Data matching the design
  final allRequests = <Map<String, dynamic>>[
    {
      'id': 'REQ-2023-101',
      'title': 'Team Lunch',
      'date': 'Oct 25, 2023',
      'amount': 124.00,
      'status': 'Approved',
      'category': 'Food & Dining',
      'icon': Icons.restaurant,
      'iconColor': Color(0xFF0EA5E9),
      'iconBg': Color(0xFFE0F2FE),
      'description': 'Monthly team lunch for the design department to celebrate project completion. Held at \'The Corner Bistro\'. All team members were present.',
      'attachments': [
        {'name': 'receipt_lunch.pdf', 'size': '1.2 MB', 'type': 'pdf'},
        {'name': 'photo_team.jpg', 'size': '3.4 MB', 'type': 'image'}
      ]
    },
    {
      'id': 'REQ-2023-102',
      'title': 'Office Supplies',
      'date': 'Oct 26, 2023',
      'amount': 75.50,
      'status': 'Pending',
      'category': 'Office',
      'icon': Icons.shopping_cart,
      'iconColor': Color(0xFF0EA5E9), 
      'iconBg': Color(0xFFE0F2FE),
      'description': 'Purchase of stationery items including notebooks, pens, and printer paper.',
      'attachments': []
    },
    {
      'id': 'REQ-2023-103',
      'title': 'Taxi to Airport',
      'date': 'Oct 22, 2023',
      'amount': 45.00,
      'status': 'Rejected',
      'category': 'Transport',
      'icon': Icons.directions_car,
      'iconColor': Color(0xFF0EA5E9),
      'iconBg': Color(0xFFE0F2FE),
       'description': 'Taxi fare for client meeting travel.',
      'attachments': []
    },
    {
      'id': 'REQ-2023-104',
      'title': 'Business Trip Flights',
      'date': 'Oct 20, 2023',
      'amount': 450.99,
      'status': 'Approved',
      'category': 'Travel',
      'icon': Icons.flight,
      'iconColor': Color(0xFF0EA5E9),
      'iconBg': Color(0xFFE0F2FE),
      'description': 'Round trip flights for the annual conference in NYC.',
      'attachments': []
    },
  ].obs;

  final searchQuery = ''.obs;

  List<Map<String, dynamic>> get filteredRequests {
    List<Map<String, dynamic>> result;
    
    // 1. Filter by Tab
    if (currentTab.value == 0) {
      result = allRequests;
    } else if (currentTab.value == 1) {
      result = allRequests.where((r) => r['status'] == 'Pending').toList();
    } else if (currentTab.value == 2) {
      result = allRequests.where((r) => r['status'] == 'Approved').toList();
    } else {
      result = allRequests.where((r) => r['status'] == 'Rejected').toList();
    }

    // 2. Filter by Search Query
    if (searchQuery.value.isNotEmpty) {
      final lowerQuery = searchQuery.value.toLowerCase();
      result = result.where((r) => 
        r['title'].toString().toLowerCase().contains(lowerQuery) || 
        r['id'].toString().toLowerCase().contains(lowerQuery)
      ).toList();
    }
    
    return result;
  }

  void searchRequests(String query) {
    searchQuery.value = query;
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void viewDetails(Map<String, dynamic> request) {
    Get.toNamed(AppRoutes.REQUEST_DETAILS_READ, arguments: request);
  }
}
