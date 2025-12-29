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
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        currentUser.value = user;
      } else {
        await logout();
      }
    }
    return this;
  }

  Future<void> login(String email, String password) async {
    final result = await _authRepository.login(email, password);
    final user = result['user'] as User;
    final token = result['token'] as String?;

    currentUser.value = user;

    if (token != null) {
      await _storageService.write('auth_token', token);
    } else {
      // Fallback to session token if no token provided
      await _storageService.write('auth_token', 'session_${user.id}');
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    currentUser.value = null;
    await _storageService.delete('auth_token');
  }
}
