import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';

class AdminDashboardController extends GetxController {
  final count = 0.obs;

  // Tab index for bottom bar
  final currentIndex = 0.obs;

  String get shortName {
    final user = Get.find<AuthService>().currentUser.value;
    if (user == null) return 'Approver';

    // User model stores full name in 'name' property
    String name = user.name;
    if (name.isEmpty || name == 'Unknown') {
      name = user.email.isNotEmpty ? user.email : 'Approver';
    }

    // Get first word as short name if it contains spaces
    if (name.contains(' ')) {
      return name.split(' ').first;
    }
    return name;
  }

  final showWelcome = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Auto-hide welcome message after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      showWelcome.value = false;
    });
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void navigateToApprovals() {
    currentIndex.value = 1;
  }
}
