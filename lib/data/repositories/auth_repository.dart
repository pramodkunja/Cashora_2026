import 'package:dio/dio.dart';
import '../../core/services/network_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final NetworkService _networkService;

  AuthRepository(this._networkService);

  Future<User> login(String email, String password) async {
    try {
      // Mocking API call for demonstration as the goal is architecture
      // final response = await _networkService.post('/auth/login', data: {'email': email, 'password': password});
      // return User.fromJson(response.data['user']);
      
      // Simulated delay
      await Future.delayed(const Duration(seconds: 2));

      if (email == 'admin@test.com') {
         return User(id: '1', email: email, name: 'Admin User', role: 'admin');
      } else if (email == 'accountant@test.com') {
         return User(id: '2', email: email, name: 'Accountant User', role: 'accountant');
      } else if (email == 'requestor@test.com') {
         return User(id: '3', email: email, name: 'Requestor User', role: 'employee');
      }

      // Default fallback
      return User(id: '0', email: email, name: 'Generic User', role: 'employee');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
     // await _networkService.post('/auth/logout');
  }
}
