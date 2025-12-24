import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  final Rx<User?> currentUser = Rx<User?>(null);
  bool get isLoggedIn => currentUser.value != null;

  AuthService(this._authRepository, this._storageService);

  Future<AuthService> init() async {
    String? token = await _storageService.read('auth_token');
    if (token != null) {
      // For now, we simulate a restored user session. 
      // ideally verify token with API.
      currentUser.value = User(id: '1', name: 'User', email: 'user@example.com', role: 'requestor'); 
    }
    return this;
  }

  Future<void> login(String email, String password) async {
    final user = await _authRepository.login(email, password);
    currentUser.value = user;
    await _storageService.write('auth_token', 'mock_token_for_${user.id}');
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser.value = null;
    await _storageService.delete('auth_token');
  }
}
