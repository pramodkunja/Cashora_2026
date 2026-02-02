import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import '../../../../routes/app_routes.dart';
import '../../../../data/repositories/payment_repository.dart';
import '../../../../core/services/network_service.dart';

class PaymentFlowController extends GetxController {
  // Dependencies
  late final PaymentRepository _paymentRepository;

  // State
  final RxBool isQrDetected = false.obs;
  final RxString selectedPaymentMethod = 'VPA'.obs; // VPA or BANK_ACCOUNT
  final RxBool isLoading = false.obs;

  // Scanned Details (keeping for QR code compatibility)
  final RxMap<String, String> scannedDetails = <String, String>{}.obs;

  // View State
  final RxString currentImageUrl = ''.obs;
  final RxString currentTitle = ''.obs;
  final RxBool isQrMode = false.obs;
  final RxBool isScanning = false.obs;

  // Current Request Data
  final RxMap<String, dynamic> currentRequest = <String, dynamic>{}.obs;

  // Payment State
  String? _currentPaymentId;
  String? _currentMerchantTxnId;
  final RxDouble requestedAmount = 150.00.obs;
  final RxDouble finalAmount = 150.00.obs;
  final adjustmentController = TextEditingController();

  // Payment Form Fields
  final vpaController = TextEditingController();
  final accountHolderController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final mobileController = TextEditingController();
  final remarksController = TextEditingController();

  // VPA Validation State
  final RxBool isVpaValid = false.obs;
  final RxBool isValidatingVpa = false.obs;
  final RxString vpaValidationMessage = ''.obs;
  final RxString vpaAccountHolderName = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Initialize dependencies
    if (!Get.isRegistered<PaymentRepository>()) {
      Get.put(PaymentRepository(Get.find<NetworkService>()));
    }
    _paymentRepository = Get.find<PaymentRepository>();

    // Parse passed Request Data
    if (Get.arguments != null && Get.arguments is Map) {
      print("PaymentFlowController Args: ${Get.arguments}");
      if (Get.arguments['request'] != null) {
        final req = Get.arguments['request'];
        try {
          final amt = double.tryParse(req['amount']?.toString() ?? '0') ?? 0.0;
          requestedAmount.value = amt;
          finalAmount.value = amt;
          currentRequest.value = req;
          print("PaymentFlowController initialized with request: ${req['id']}");
        } catch (e) {
          print("Error parsing request args: $e");
        }
      }

      // Init View Data
      currentImageUrl.value = Get.arguments['url'] ?? '';
      currentTitle.value = Get.arguments['title'] ?? 'Details';
      isQrMode.value = Get.arguments['isQr'] ?? false;

      print("Init QR Mode: ${isQrMode.value}, URL: ${currentImageUrl.value}");

      if (isQrMode.value && currentImageUrl.isNotEmpty) {
        analyzeQrCode(currentImageUrl.value);
      }
    } else {
      print("PaymentFlowController initialized with NO ARGUMENTS");
    }
  }

  @override
  void onClose() {
    adjustmentController.dispose();
    vpaController.dispose();
    accountHolderController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    mobileController.dispose();
    remarksController.dispose();
    super.onClose();
  }

  void prepareForView({
    required String url,
    required String title,
    bool isQr = false,
  }) {
    print("Preparing View: URL=$url, Title=$title, IsQR=$isQr");
    currentImageUrl.value = url;
    currentTitle.value = title;
    isQrMode.value = isQr;

    // Clear previous scan results
    isQrDetected.value = false;
    scannedDetails.clear();
    isScanning.value = false;
    _currentPaymentId = null;
    _currentMerchantTxnId = null;

    if (isQr && url.isNotEmpty) {
      analyzeQrCode(url);
    }
  }

  Future<File?> _downloadImage(String url) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath =
          '${directory.path}/qr_temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await Dio().download(url, filePath);
      return File(filePath);
    } catch (e) {
      print("Error downloading QR: $e");
      return null;
    }
  }

  Future<void> analyzeQrCode(String imageUrl) async {
    isScanning.value = true;
    isQrDetected.value = false;
    scannedDetails.clear();

    try {
      final file = await _downloadImage(imageUrl);
      if (file == null) {
        Get.snackbar('Error', 'Failed to load QR image');
        isScanning.value = false;
        return;
      }

      final MobileScannerController controller = MobileScannerController();
      final BarcodeCapture? capture = await controller.analyzeImage(file.path);

      if (capture != null && capture.barcodes.isNotEmpty) {
        final String? rawValue = capture.barcodes.first.rawValue;
        if (rawValue != null) {
          _validateAndParseUpi(rawValue);
        } else {
          Get.snackbar('Invalid QR', 'No data found in QR code');
        }
      } else {
        Get.snackbar('Error', 'Could not detect QR code');
      }
    } catch (e) {
      print("QR Analysis Error: $e");
      Get.snackbar('Error', 'Failed to analyze QR code');
    } finally {
      isScanning.value = false;
    }
  }

  void _validateAndParseUpi(String uriString) {
    if (!uriString.startsWith('upi://pay')) {
      Get.snackbar('Invalid QR', 'This is not a valid Payment QR');
      return;
    }

    try {
      final uri = Uri.parse(uriString);
      final params = uri.queryParameters;

      final pa = params['pa'] ?? ''; // Payee Address
      final pn = params['pn'] ?? ''; // Payee Name
      final am = params['am'] ?? ''; // Amount

      if (pa.isEmpty) {
        Get.snackbar('Invalid QR', 'Missing Payee Address (VPA)');
        return;
      }

      // Amount validation
      double? parsedAmt;
      if (am.isNotEmpty) {
        parsedAmt = double.tryParse(am);
        if (parsedAmt != null) {
          if ((parsedAmt - requestedAmount.value).abs() > 0.01) {
            Get.snackbar(
              'Amount Mismatch',
              'QR Amount (₹$parsedAmt) does not match Request Amount (₹${requestedAmount.value})',
              backgroundColor: Colors.orange.withOpacity(0.9),
              colorText: Colors.white,
              duration: const Duration(seconds: 4),
            );
          }
          finalAmount.value = parsedAmt;
        }
      }

      // Store scanned details
      final newDetails = <String, String>{};
      params.forEach((key, value) {
        newDetails[key] = value;
      });

      newDetails['pa'] = pa;
      newDetails['pn'] = pn;
      newDetails['am'] = am;
      newDetails['uri'] = uriString;

      scannedDetails.value = newDetails;
      isQrDetected.value = true;

      // Pre-fill VPA field
      vpaController.text = pa;
      
      // Auto-validate the VPA
      validateVPA(pa);
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse UPI QR');
    }
  }

  /// Validate VPA (UPI ID)
  Future<void> validateVPA(String vpa) async {
    if (vpa.isEmpty || !vpa.contains('@')) {
      isVpaValid.value = false;
      vpaValidationMessage.value = 'Invalid UPI ID format';
      return;
    }

    isValidatingVpa.value = true;
    vpaValidationMessage.value = '';
    vpaAccountHolderName.value = '';

    try {
      print('🔍 Validating VPA: $vpa');
      final result = await _paymentRepository.validateVPA(vpa);

      isVpaValid.value = result['is_valid'] ?? false;
      
      if (isVpaValid.value) {
        vpaAccountHolderName.value = result['account_holder_name'] ?? '';
        vpaValidationMessage.value = 'Valid UPI ID';
        print('✅ VPA is valid: ${vpaAccountHolderName.value}');
      } else {
        vpaValidationMessage.value = 'Invalid UPI ID';
        print('❌ VPA is invalid');
      }
    } catch (e) {
      isVpaValid.value = false;
      vpaValidationMessage.value = 'Validation failed';
      print('❌ VPA validation error: $e');
    } finally {
      isValidatingVpa.value = false;
    }
  }

  /// Start PhonePe payment flow
  Future<void> startPhonePePayment() async {
    final parsedAmount = finalAmount.value;
    final expenseId = currentRequest['id'] as int?;
    
    if (expenseId == null) {
      Get.snackbar('Error', 'Invalid expense ID');
      return;
    }

    print('💳 Starting PhonePe Payment Flow');
    print('   Expense ID: $expenseId');
    print('   Amount: ₹$parsedAmount');
    print('   Payment Method: ${selectedPaymentMethod.value}');

    // Validate inputs
    if (selectedPaymentMethod.value == 'VPA') {
      if (vpaController.text.isEmpty) {
        Get.snackbar('Error', 'Please enter UPI ID');
        return;
      }
      if (!isVpaValid.value) {
        Get.snackbar('Error', 'Please enter a valid UPI ID');
        return;
      }
    } else if (selectedPaymentMethod.value == 'BANK_ACCOUNT') {
      if (accountHolderController.text.isEmpty ||
          accountNumberController.text.isEmpty ||
          ifscController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all bank account details');
        return;
      }
    }

    if (mobileController.text.isEmpty || mobileController.text.length != 10) {
      Get.snackbar('Error', 'Please enter a valid 10-digit mobile number');
      return;
    }

    isLoading.value = true;
    try {
      // Step 1: Initiate Payment on Backend
      print('📡 Initiating PhonePe payout...');
      final result = await _paymentRepository.initiatePhonePePayout(
        expenseId: expenseId,
        paymentMethod: selectedPaymentMethod.value,
        vpaAddress: selectedPaymentMethod.value == 'VPA' ? vpaController.text : null,
        accountHolderName: selectedPaymentMethod.value == 'BANK_ACCOUNT' 
            ? accountHolderController.text : null,
        accountNumber: selectedPaymentMethod.value == 'BANK_ACCOUNT' 
            ? accountNumberController.text : null,
        ifscCode: selectedPaymentMethod.value == 'BANK_ACCOUNT' 
            ? ifscController.text : null,
        mobileNumber: mobileController.text,
        remarks: remarksController.text.isNotEmpty ? remarksController.text : null,
      );

      final paymentId = result['payment_id'];
      final merchantTxnId = result['merchant_transaction_id'];
      
      if (paymentId == null) throw "No payment ID returned from backend";

      _currentPaymentId = paymentId;
      _currentMerchantTxnId = merchantTxnId;
      
      print('✅ Payment initiated successfully');
      print('   Payment ID: $paymentId');
      print('   Merchant Txn ID: $merchantTxnId');

      // Step 2: Poll for payment status
      print('🔄 Starting status polling...');
      await _pollPaymentStatus(paymentId);
      
    } catch (e) {
      print("❌ Payment Error: $e");
      String errorMsg = "Failed to initiate payment";
      if (e is DioException && e.response?.data != null) {
        errorMsg =
            e.response?.data['detail'] ??
            e.response?.data['message'] ??
            e.message ??
            errorMsg;
      } else {
        errorMsg = "$errorMsg: ${e.toString()}";
      }

      Get.snackbar(
        "Payment Error",
        errorMsg,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Poll payment status until completion
  Future<void> _pollPaymentStatus(String paymentId) async {
    const maxAttempts = 20;
    const intervalSeconds = 5;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      print('🔄 Polling payment status... (Attempt $attempt/$maxAttempts)');

      try {
        final statusResponse = await _paymentRepository.checkPhonePeStatus(
          paymentId: paymentId,
        );

        final status = statusResponse['status'];
        print('   Status: $status');

        // Log full response for debugging
        print('--------------------------------------------------');
        print('       PHONEPE PAYMENT STATUS REPORT       ');
        print('--------------------------------------------------');
        print('Payment ID         : ${statusResponse['payment_id']}');
        print('Merchant Txn ID    : ${statusResponse['merchant_transaction_id']}');
        print('PhonePe Txn ID     : ${statusResponse['phonepe_transaction_id']}');
        print('Status             : $status');
        print('Code               : ${statusResponse['code']}');
        print('Message            : ${statusResponse['message']}');
        print('Amount             : ₹${statusResponse['amount']}');
        print('Beneficiary        : ${statusResponse['beneficiary_name']}');
        print('Account Type       : ${statusResponse['account_type']}');
        print('Initiated At       : ${statusResponse['initiated_at']}');
        print('Completed At       : ${statusResponse['completed_at']}');
        print('--------------------------------------------------');

        // Check if payment is complete
        if (status == 'PAYMENT_SUCCESS') {
          print('✅ PhonePe: Payment completed successfully');
          _navigateToSuccess(statusResponse);
          return;
        }

        if (status == 'PAYMENT_ERROR' || status == 'PAYMENT_DECLINED') {
          print('❌ PhonePe: Payment failed');
          _navigateToFailure(statusResponse);
          return;
        }

        // Still pending, wait before next poll
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: intervalSeconds));
        }
      } catch (e) {
        print('⚠️ PhonePe: Polling attempt $attempt failed: $e');
        if (attempt < maxAttempts) {
          await Future.delayed(const Duration(seconds: intervalSeconds));
        } else {
          // Final attempt failed
          Get.offNamed(
            AppRoutes.ACCOUNTANT_PAYMENT_FAILED,
            arguments: {
              'amount': finalAmount.value,
              'error': 'Payment status check timeout',
              'payee': scannedDetails['pn'] ?? vpaAccountHolderName.value,
              'date': DateTime.now().toIso8601String(),
              'txnId': _currentMerchantTxnId ?? 'N/A',
            },
          );
          return;
        }
      }
    }

    // Timeout
    print('⏱️ PhonePe: Payment status polling timeout');
    Get.offNamed(
      AppRoutes.ACCOUNTANT_PAYMENT_FAILED,
      arguments: {
        'amount': finalAmount.value,
        'error': 'Payment timeout after ${maxAttempts * intervalSeconds} seconds',
        'payee': scannedDetails['pn'] ?? vpaAccountHolderName.value,
        'date': DateTime.now().toIso8601String(),
        'txnId': _currentMerchantTxnId ?? 'N/A',
      },
    );
  }

  void _navigateToSuccess(Map<String, dynamic> statusResponse) {
    Get.offNamed(
      AppRoutes.ACCOUNTANT_PAYMENT_SUCCESS,
      arguments: {
        'amount': statusResponse['amount'] ?? finalAmount.value,
        'txnId': statusResponse['phonepe_transaction_id'] ?? 
                 statusResponse['merchant_transaction_id'] ?? 'N/A',
        'merchantTxnId': statusResponse['merchant_transaction_id'],
        'payee': statusResponse['beneficiary_name'] ?? 
                 scannedDetails['pn'] ?? 
                 vpaAccountHolderName.value,
        'date': statusResponse['completed_at'] ?? DateTime.now().toIso8601String(),
        'paymentSource': 'PhonePe',
        'accountType': statusResponse['account_type'],
      },
    );
  }

  void _navigateToFailure(Map<String, dynamic> statusResponse) {
    Get.offNamed(
      AppRoutes.ACCOUNTANT_PAYMENT_FAILED,
      arguments: {
        'amount': statusResponse['amount'] ?? finalAmount.value,
        'error': statusResponse['message'] ?? 'Payment failed',
        'payee': statusResponse['beneficiary_name'] ?? 
                 scannedDetails['pn'] ?? 
                 vpaAccountHolderName.value,
        'date': statusResponse['initiated_at'] ?? DateTime.now().toIso8601String(),
        'txnId': statusResponse['phonepe_transaction_id'] ?? 
                 statusResponse['merchant_transaction_id'] ?? 'N/A',
      },
    );
  }

  void backToDashboard() {
    Get.offAllNamed(AppRoutes.ACCOUNTANT_DASHBOARD);
  }
}
