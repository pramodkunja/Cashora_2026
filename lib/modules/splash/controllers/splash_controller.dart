import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../lock/views/lock_view.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final AuthService _authService = Get.find<AuthService>();
  
  // Animation duration
  final int splashDuration = 5000;
  
  // Progress bar
  final RxDouble progress = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  void _startLoading() async {
    // Simulate loading steps (e.g., config, user data, etc.)
    // Step 1: Initialize (0-30%)
    await Future.delayed(const Duration(milliseconds: 500)); 

    // FORCE RESET REMOVED: Implementation of persistent options
    progress.value = 0.3;
    
    // Step 2: Check Auth / Load Resources (30-80%)
    await Future.delayed(const Duration(milliseconds: 1000));
    progress.value = 0.8;
    
    // Step 3: Finalizing (80-100%)
    await Future.delayed(const Duration(milliseconds: 500));
    progress.value = 1.0;
    
    // Navigate after animation completes
    Future.delayed(const Duration(milliseconds: 500), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    // 1. Check if logged in
    if (_authService.isLoggedIn) {
      final storage = Get.find<StorageService>();
      String? enabled = await storage.read('face_id_enabled');
      
      // Always navigate to the main app first using RouteGuard logic (INITIAL)
      Get.offAllNamed(AppRoutes.INITIAL);
      
      if (enabled == 'true') {
        // Overlay the LockView
        Get.to(() => const LockView(), opaque: false, fullscreenDialog: true);
      }
    } else {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
