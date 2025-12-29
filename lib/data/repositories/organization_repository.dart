import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';

class OrganizationRepository {
  final NetworkService _networkService;

  OrganizationRepository(this._networkService);

  Future<void> createOrganization({
    required String orgName,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    try {
      final data = {
        "org_name": orgName,
        "admin_details": {
          "email": email,
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": phoneNumber,
        }
      };

      await _networkService.post('/auth/setup-organization', data: data);
    } catch (e) {
      rethrow;
    }
  }
}
