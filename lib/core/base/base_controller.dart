import 'package:get/get.dart';

class BaseController extends GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxString _errorMessage = ''.obs;
  String get errorMessage => _errorMessage.value;

  void showLoading() {
    _isLoading.value = true;
  }

  void hideLoading() {
    _isLoading.value = false;
  }

  void handleError(dynamic error) {
    hideLoading();
    _errorMessage.value = error.toString();
    Get.snackbar('Error', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
  }
  
  Future<void> performAsyncOperation(Future<void> Function() operation) async {
    try {
      showLoading();
      await operation();
    } catch (e) {
      handleError(e);
    } finally {
      hideLoading();
    }
  }
}
