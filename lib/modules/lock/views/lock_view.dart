import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/biometric_service.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../../../routes/app_routes.dart';

class LockView extends StatefulWidget {
  const LockView({Key? key}) : super(key: key);

  @override
  State<LockView> createState() => _LockViewState();
}

class _LockViewState extends State<LockView> {
  final BiometricService _biometricService = Get.find<BiometricService>();

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool authenticated = await _biometricService.authenticate();
    if (authenticated) {
      // Unlock successful -> Go to Dashboard (via RouteGuard/Initial or direct)
      // Since Splash navigates here replacing itself, we should navigate to the next intended screen.
      // Ideally, we should check role again or just go to AppRoutes.INITIAL which has RouteGuard.
      Get.offAllNamed(AppRoutes.INITIAL); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Scaffold(
        backgroundColor: AppColors.primaryBlue,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'App Locked',
                style: AppTextStyles.h1.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Unlock', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
