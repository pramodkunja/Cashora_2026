import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/payment_response_model.dart';

class AccountantRepository {
  final NetworkService _networkService;

  AccountantRepository(this._networkService);

  Future<PaymentResponse> getPendingPayments() async {
    try {
      final response = await _networkService.get(
        '/accountant/expenses/pending-payments',
        // queryParameters: {
        //   'status': ['approved', 'auto_approved']
        // },
      );

      return PaymentResponse.fromJson(response.data);
    } catch (e) {
      print("Error fetching pending payments: $e");
      rethrow;
    }
  }
}
