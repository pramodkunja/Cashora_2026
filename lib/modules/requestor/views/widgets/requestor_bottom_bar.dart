import 'package:flutter/material.dart';
import '../../../../utils/app_text.dart';

class RequestorBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const RequestorBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0EA5E9), // Sky Blue
        unselectedItemColor: const Color(0xFF94A3B8), // Slate 400
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: AppText.dashboard,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: AppText.requests,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: AppText.profile,
          ),
        ],
      ),
    );
  }
}
