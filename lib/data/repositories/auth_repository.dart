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
      return User(id: '1', email: email, name: 'John Doe', role: 'admin');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
     // await _networkService.post('/auth/logout');
  }
}
