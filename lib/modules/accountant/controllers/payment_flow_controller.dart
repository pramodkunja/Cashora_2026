import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../../../core/services/network_service.dart';
import '../../../../utils/widgets/app_loader.dart';

class PaymentFlowController extends GetxController {

  // Dependencies
  late final PaymentRepository _paymentRepository;

  // State
  final RxBool isQrDetected = false.obs;
  final RxString selectedPaymentSource = 'Bank Transfer / UPI'.obs; // Default to Digital
  final RxString selectedPaymentApp = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Lazy find or put if not already there (assuming main.dart registers it, otherwise we can put it here for safety, but better in main)
    // Lazy find or put if not already there
    if (!Get.isRegistered<PaymentRepository>()) {
      Get.put(PaymentRepository(Get.find<NetworkService>())); // Ensure NetworkService is available (usually is)
    }
    _paymentRepository = Get.find<PaymentRepository>();
  
    // Check arguments if any
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['simulateQr'] != null) {
        shouldSimulateQrDetection = Get.arguments['simulateQr'];
      }
      
      // Parse passed Request Data
      if (Get.arguments['request'] != null) {
        final req = Get.arguments['request'];
        try {
          final amt = double.tryParse(req['amount']?.toString() ?? '0') ?? 0.0;
          requestedAmount.value = amt;
          finalAmount.value = amt;
          // Store Full Request Data if needed for UI or Backend
          // currentRequest.value = req;
        } catch (e) {
          print("Error parsing request args: $e");
        }
      }
    }
  }

  // Scenarios
  bool shouldSimulateQrDetection = true; 

  // Payment Logic
  final RxDouble requestedAmount = 150.00.obs;
  final RxDouble finalAmount = 150.00.obs;
  final adjustmentController = TextEditingController();


  @override
  void onClose() {
    adjustmentController.dispose();
    super.onClose();
  }

  // Called when Bill Details screen is opened
  void startQrSimulation() async {
    if (!shouldSimulateQrDetection) return;

    // Reset first
    isQrDetected.value = false;

    // Simulate delay
    await Future.delayed(const Duration(seconds: 2)); // 1.5 - 2s delay
    isQrDetected.value = true;
  }

  void onUseForPayment() {
    Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_VERIFY);
  }

  void selectPaymentSource(String source) {
    selectedPaymentSource.value = source;
  }

  void onMakePayment() {
    if (selectedPaymentSource.isEmpty) {
      Get.snackbar('Error', 'Please select a payment source');
      return;
    }
    Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_CONFIRM);
  }

  void selectPaymentApp(String appName) {
    selectedPaymentApp.value = appName;
  }

  void backToDashboard() {
    Get.offAllNamed(AppRoutes.ACCOUNTANT_DASHBOARD);
  }

  void onPayViaUpi() async {
    if (selectedPaymentApp.isEmpty) {
      Get.snackbar('Error', 'Please select a payment app');
      return;
    }

    // Handle Custom/Manual Payment
    if (selectedPaymentApp.value == 'Custom') {
      _handleCustomPayment();
      return;
    }
    
    // Construct UPI URI
    // SECURITY NOTE: VPA is hardcoded here. Should be fetched from config.
    final upiUri = Uri.parse(
      'upi://pay?pa=9490997946@hdfc&pn=Office%20Supplies%20Co.&am=${finalAmount.value}&cu=INR&tn=Invoice%20Inv-2023-001'
    );

    try {
      bool launched = await launchUrl(
        upiUri, 
        mode: LaunchMode.externalApplication,
      );
      
      if (!launched) {
        throw 'Could not launch UPI intent';
      }
      
      // If launched successfully, ask for confirmation
      Get.dialog(
        AlertDialog(
          title: const Text('Payment Confirmation'),
          content: const Text('Did you complete the payment successfully in the UPI app?'),
          actions: [
             TextButton(
              onPressed: () => Get.back(), // Stay on page
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back(); // Close dialog
                await _processBackendPayment(
                  method: 'UPI', 
                  txnId: 'UPI-${DateTime.now().millisecondsSinceEpoch}', // Placeholder if we can't get real ID
                ); 
              },
              child: const Text('Yes, Payment Done'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

    } catch (e) {
      print('Error launching UPI: $e');
      Get.toNamed(AppRoutes.ACCOUNTANT_PAYMENT_FAILED);
    }
  }

  void _handleCustomPayment() {
    final txnController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Enter Transaction Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter the Transaction ID (Reference No.) from your payment app.'),
            const SizedBox(height: 16),
            TextField(
              controller: txnController,
              decoration: const InputDecoration(
                labelText: 'Transaction ID',
                border: OutlineInputBorder(),
                hintText: 'e.g., UPI-123456789',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => isLoading.value 
            ? const Center(child: AppLoader())
            : ElevatedButton(
              onPressed: () async {
                if (txnController.text.isEmpty) {
                  Get.snackbar('Required', 'Please enter Transaction ID');
                  return;
                }
                Get.back(); // Close dialog
                await _processBackendPayment(
                  method: 'CUSTOM',
                  txnId: txnController.text,
                );
              },
              child: const Text('Confirm Payment'),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _processBackendPayment({required String method, required String txnId}) async {
    try {
      isLoading.value = true;
      await _paymentRepository.recordPayment(
        amount: finalAmount.value,
        method: method,
        transactionId: txnId,
      );
      isLoading.value = false;
      Get.offNamed(AppRoutes.ACCOUNTANT_PAYMENT_SUCCESS);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Payment Error', 'Failed to record payment: $e');
      // Do not navigate to success flow if backend fails
    }
  }
}
