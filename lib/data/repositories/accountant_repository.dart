import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';

class AccountantRepository {
  final NetworkService _networkService;

  AccountantRepository(this._networkService);

  Future<List<Map<String, dynamic>>> getPendingPayments() async {
    try {
      final response = await _networkService.get(
        '/accountant/expenses/pending-payments',
      );

      // Handle the specific response structure: { "items": [...] }
      if (response.data is Map && response.data['items'] is List) {
        return List<Map<String, dynamic>>.from(response.data['items']);
      } else if (response.data is List) {
        // Fallback if API returns list directly
        return List<Map<String, dynamic>>.from(response.data);
      }
      
      return [];
    } catch (e) {
      print("Error fetching pending payments: $e");
      rethrow;
    }
  }
}
