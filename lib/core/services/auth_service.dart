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
    // Check for persisted session logic can go here
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
