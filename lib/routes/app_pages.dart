import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/admin/views/admin_dashboard_view.dart';
import '../modules/admin/views/admin_approvals_view.dart';
import '../modules/admin/views/admin_request_details_view.dart';
import '../modules/admin/views/admin_success_view.dart';
import '../modules/admin/controllers/admin_dashboard_controller.dart';
import '../modules/admin/controllers/admin_approvals_controller.dart';
import '../modules/admin/controllers/admin_request_details_controller.dart';
import '../modules/admin/controllers/admin_request_details_controller.dart';
import '../modules/admin/views/admin_rejection_success_view.dart';
import '../modules/admin/views/admin_clarification_view.dart';
import '../modules/admin/views/admin_clarification_success_view.dart';
import '../modules/admin/views/admin_history_view.dart';

import '../modules/admin/views/admin_clarification_status_view.dart';
import '../modules/admin/controllers/admin_clarification_status_controller.dart';
import '../modules/admin/controllers/admin_history_controller.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/settings_view.dart';
import '../modules/profile/controllers/profile_controller.dart';
import '../modules/profile/controllers/settings_controller.dart';
import '../modules/settings/views/notifications_view.dart';
import '../modules/settings/views/appearance_view.dart';
import '../modules/settings/views/change_password_view.dart';
import '../modules/admin/views/user_management/admin_user_list_view.dart';
import '../modules/admin/views/user_management/admin_add_user_view.dart';
import '../modules/admin/views/user_management/admin_edit_user_view.dart';
import '../modules/admin/views/user_management/admin_deactivate_user_view.dart';
import '../modules/admin/views/user_management/admin_user_success_view.dart';
import '../modules/admin/controllers/admin_user_controller.dart';
import 'app_routes.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/organization_setup/bindings/organization_setup_binding.dart';
import '../modules/organization_setup/views/organization_setup_view.dart';
import '../modules/organization_setup/views/organization_success_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/otp_verification/bindings/otp_verification_binding.dart';
import '../modules/otp_verification/views/otp_verification_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/reset_password/views/reset_password_success_view.dart';
import '../modules/requestor/bindings/requestor_binding.dart';
// import '../modules/requestor/views/requestor_view.dart';
import '../modules/requestor/bindings/create_request_binding.dart';
import '../modules/requestor/views/create_request/select_request_type_view.dart';
import '../modules/requestor/views/create_request/request_details_view.dart';
import '../modules/requestor/views/create_request/review_request_view.dart';
import '../modules/requestor/views/create_request/request_success_view.dart';
import '../modules/requestor/views/monthly_spent_view.dart';
import '../modules/requestor/views/my_requests_view.dart';
import '../modules/requestor/views/request_details_read_view.dart';
import '../modules/requestor/controllers/my_requests_controller.dart';
import '../core/services/auth_service.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (!Get.find<AuthService>().isLoggedIn) {
      return const RouteSettings(name: AppRoutes.LOGIN);
    }
    return null;
  }
  }


class RouteGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return const RouteSettings(name: AppRoutes.HOME);
  }
}


class AppPages {
  static const INITIAL = AppRoutes.ADMIN_DASHBOARD;

  static final routes = [
    GetPage(
      name: AppRoutes.INITIAL, // '/'
      page: () => const SizedBox(), // Placeholder, middleware will redirect or it redirects to Home
      middlewares: [
        RouteGuard(),
      ],
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.ORGANIZATION_SETUP,
      page: () => const OrganizationSetupView(),
      binding: OrganizationSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.ORGANIZATION_SUCCESS,
      page: () => const OrganizationSuccessView(),
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => const OtpVerificationView(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD_SUCCESS,
      page: () => const ResetPasswordSuccessView(),
    ),
    // GetPage(
    //   name: AppRoutes.REQUESTOR,
    //   page: () => const RequestorView(),
    //   binding: RequestorBinding(),
    // ),
    GetPage(
      name: AppRoutes.CREATE_REQUEST_TYPE,
      page: () => const SelectRequestTypeView(),
      binding: CreateRequestBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_REQUEST_DETAILS,
      page: () => const RequestDetailsView(),
      binding: CreateRequestBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_REQUEST_REVIEW,
      page: () => const ReviewRequestView(),
      binding: CreateRequestBinding(),
    ),
    GetPage(
      name: AppRoutes.CREATE_REQUEST_SUCCESS,
      page: () => const RequestSuccessView(),
      binding: CreateRequestBinding(),
    ),
    GetPage(
      name: AppRoutes.MY_REQUESTS,
      page: () => const MyRequestsView(),
      binding: BindingsBuilder(() {
        Get.put(MyRequestsController());
      }),
    ),
    GetPage(
      name: AppRoutes.MONTHLY_SPENT,
      page: () => const MonthlySpentView(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: BindingsBuilder(() {
        Get.put(AdminDashboardController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_APPROVALS,
      page: () => const AdminApprovalsView(),
      binding: BindingsBuilder(() {
        Get.put(AdminApprovalsController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_REQUEST_DETAILS,
      page: () => const AdminRequestDetailsView(),
      binding: BindingsBuilder(() {
        Get.put(AdminRequestDetailsController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_SUCCESS,
      page: () => const AdminSuccessView(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_REJECTION_SUCCESS,
      page: () => const AdminRejectionSuccessView(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_CLARIFICATION,
      page: () => const AdminClarificationView(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_CLARIFICATION_SUCCESS,
      page: () => const AdminClarificationSuccessView(),
    ),
    GetPage(
      name: AppRoutes.ADMIN_HISTORY,
      page: () => const AdminHistoryView(),
      binding: BindingsBuilder(() {
        Get.put(AdminHistoryController());
      }),
    ),

    GetPage(
      name: AppRoutes.ADMIN_CLARIFICATION_STATUS,
      page: () => const AdminClarificationStatusView(),
      binding: BindingsBuilder(() {
        Get.put(AdminClarificationStatusController());
      }),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.SETTINGS_NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.SETTINGS_APPEARANCE,
      page: () => const AppearanceView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.SETTINGS_CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: BindingsBuilder(() {
        Get.put(SettingsController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_USER_LIST,
      page: () => const AdminUserListView(),
      binding: BindingsBuilder(() {
        Get.put(AdminUserController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_ADD_USER,
      page: () => const AdminAddUserView(),
       binding: BindingsBuilder(() {
        Get.put(AdminUserController()); // Reuse controller
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_EDIT_USER,
      page: () => const AdminEditUserView(),
       binding: BindingsBuilder(() {
        Get.put(AdminUserController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_DEACTIVATE_USER,
      page: () => const AdminDeactivateUserView(),
       binding: BindingsBuilder(() {
        Get.put(AdminUserController());
      }),
    ),
    GetPage(
      name: AppRoutes.ADMIN_USER_SUCCESS,
      page: () => const AdminUserSuccessView(),
    ),
  ];
}
