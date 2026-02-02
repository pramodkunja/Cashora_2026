import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../../core/services/storage_service.dart';

class PaymentRepository {
  final NetworkService _networkService;

  PaymentRepository(this._networkService);

  Future<void> recordPayment({
    required double amount,
    required String method, // 'UPI', 'CASH', 'CUSTOM'
    String? transactionId,
    String? note,
  }) async {
    try {
      await _networkService.post(
        '/payments/record',
        data: {
          'amount': amount,
          'payment_method': method,
          'transaction_id': transactionId,
          'note': note,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    try {
      final response = await _networkService.get('/payments/history');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
      return [];
    } catch (e) {
      // Return empty list on error for now, or rethrow based on UI needs
      return [];
    }
  }

  Future<Map<String, dynamic>> initiatePayment({
    required String requestId,
    required String payeeVpa,
    required double amount,
    String? payeeName,
    String? transactionNote,
  }) async {
    try {
      // Fetch token explicitly as requested
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final response = await _networkService.post(
        '/payments/initiate',
        data: {
          'request_id': requestId,
          'payee_vpa': payeeVpa,
          'amount': amount,
          'payee_name': payeeName,
          'transaction_note': transactionNote,
        },
        // Explicitly set header as per guide to ensure it's passed correctly
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data; // Expecting { "payment_id": "..." }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> confirmPayment({
    required String paymentId,
    required String status,
    String? upiTxnId,
    String? errorMessage,
  }) async {
    try {
      // Fetch token explicitly as requested
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final response = await _networkService.post(
        '/payments/confirm',
        data: {
          'payment_id': paymentId,
          'status': status,
          'upi_txn_id': upiTxnId,
          'error_message': errorMessage,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getCompletedPayments() async {
    try {
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final response = await _networkService.get(
        '/payments/completed',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data is Map && response.data['payments'] is List) {
        return List<Map<String, dynamic>>.from(response.data['payments']);
      }
      return [];
    } catch (e) {
      print("Error fetching completed payments: $e");
      return [];
    }
  }

  /// Initiate PhonePe payout
  /// 
  /// [expenseId] - ID of the expense to pay
  /// [paymentMethod] - "VPA" or "BANK_ACCOUNT"
  /// [vpaAddress] - UPI ID (required if paymentMethod is VPA)
  /// [accountHolderName] - Account holder name (required if BANK_ACCOUNT)
  /// [accountNumber] - Bank account number (required if BANK_ACCOUNT)
  /// [ifscCode] - IFSC code (required if BANK_ACCOUNT)
  /// [mobileNumber] - Beneficiary mobile number (required)
  /// [remarks] - Payment remarks (optional)
  /// 
  /// Returns payment details including payment_id and transaction IDs
  Future<Map<String, dynamic>> initiatePhonePePayout({
    required int expenseId,
    required String paymentMethod,
    String? vpaAddress,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    required String mobileNumber,
    String? remarks,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final requestData = {
        'expense_id': expenseId,
        'payment_method': paymentMethod,
        'mobile_number': mobileNumber,
        if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
      };

      if (paymentMethod == 'VPA' && vpaAddress != null) {
        requestData['vpa_address'] = vpaAddress;
      } else if (paymentMethod == 'BANK_ACCOUNT') {
        if (accountHolderName != null) {
          requestData['account_holder_name'] = accountHolderName;
        }
        if (accountNumber != null) {
          requestData['account_number'] = accountNumber;
        }
        if (ifscCode != null) {
          requestData['ifsc_code'] = ifscCode;
        }
      }

      final response = await _networkService.post(
        '/api/v1/phonepe/payout/initiate',
        data: requestData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print('Error initiating PhonePe payout: $e');
      rethrow;
    }
  }

  /// Check PhonePe payment status
  /// 
  /// [paymentId] - Payment ID (optional)
  /// [merchantTransactionId] - Merchant transaction ID (optional)
  /// 
  /// At least one ID must be provided
  Future<Map<String, dynamic>> checkPhonePeStatus({
    String? paymentId,
    String? merchantTransactionId,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final requestData = <String, dynamic>{};
      if (paymentId != null) requestData['payment_id'] = paymentId;
      if (merchantTransactionId != null) {
        requestData['merchant_transaction_id'] = merchantTransactionId;
      }

      final response = await _networkService.post(
        '/api/v1/phonepe/payout/status',
        data: requestData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print('Error checking PhonePe status: $e');
      rethrow;
    }
  }

  /// Validate VPA (UPI ID)
  /// 
  /// [vpaAddress] - UPI ID to validate
  Future<Map<String, dynamic>> validateVPA(String vpaAddress) async {
    try {
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final response = await _networkService.post(
        '/api/v1/phonepe/validate-vpa',
        data: {'vpa_address': vpaAddress},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print('Error validating VPA: $e');
      rethrow;
    }
  }

  /// Get PhonePe payment history
  /// 
  /// [expenseId] - Filter by expense ID (optional)
  /// [status] - Filter by status (optional)
  /// [limit] - Number of records (default: 50)
  Future<Map<String, dynamic>> getPhonePePaymentHistory({
    int? expenseId,
    String? status,
    int limit = 50,
  }) async {
    try {
      final storage = Get.find<StorageService>();
      final token = await storage.read('auth_token');

      final queryParams = <String, dynamic>{};
      if (expenseId != null) queryParams['expense_id'] = expenseId;
      if (status != null) queryParams['status'] = status;
      queryParams['limit'] = limit;

      final response = await _networkService.get(
        '/api/v1/phonepe/payments/history',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      print('Error fetching PhonePe payment history: $e');
      rethrow;
    }
  }
}
