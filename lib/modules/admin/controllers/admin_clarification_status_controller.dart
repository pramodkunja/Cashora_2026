import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/app_text.dart';

enum ClarificationState {
  pending,
  responded,
  askingAgain,
}

class AdminClarificationStatusController extends GetxController {
  final Rx<ClarificationState> state = ClarificationState.pending.obs;
  final RxMap<String, dynamic> request = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      request.value = Get.arguments;
      // Mock logic: If the ID is 'REQ-2023-889' (History item), set to Responded state
      if (request['id'] == 'REQ-2023-889') {
        state.value = ClarificationState.responded;
      }
    }
  }

  void toggleSimulateResponse() {
    if (state.value == ClarificationState.pending) {
      state.value = ClarificationState.responded;
    } else {
      state.value = ClarificationState.pending;
    }
  }

  void startAskAgain() {
    state.value = ClarificationState.askingAgain;
  }

  void submitAskAgain() {
    // Logic to send second clarification
    // For now, go back to pending
    Get.snackbar(AppText.success, AppText.sentBackSuccessfully);
    state.value = ClarificationState.pending;
  }

  void approve() {
    Get.back();
    Get.snackbar(AppText.approvedSuccessTitle, AppText.approvedSuccessDesc);
  }

  void reject() {
    // Show rejection dialog or logic
    // For now reusing the success/back pattern
    Get.back();
    Get.snackbar(AppText.requestRejected, AppText.requestRejectedDesc);
  }
}
