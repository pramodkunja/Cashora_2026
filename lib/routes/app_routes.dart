abstract class AppRoutes {
  static const INITIAL = '/';
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const ORGANIZATION_SETUP = '/setup-organization';
  static const ORGANIZATION_SUCCESS = '/organization-success';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const OTP_VERIFICATION = '/otp-verification';
  static const RESET_PASSWORD = '/reset-password';
  static const RESET_PASSWORD_SUCCESS = '/reset-password-success';
  static const ENTERPRISE_SETUP = '/enterprise-setup';
  
  // Admin
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_APPROVALS = '/admin/approvals';
  static const ADMIN_REQUEST_DETAILS = '/admin/request-details';
  static const ADMIN_SUCCESS = '/admin/success';
  static const ADMIN_REJECTION_SUCCESS = '/admin/rejection-success';
  static const ADMIN_CLARIFICATION = '/admin/clarification';
  static const ADMIN_CLARIFICATION_SUCCESS = '/admin/clarification-success';
  static const ADMIN_CLARIFICATION_STATUS = '/admin/clarification-status';
  static const ADMIN_HISTORY = '/admin/history';

  static const ADMIN_USER_LIST = '/admin/users';
  static const ADMIN_ADD_USER = '/admin/users/add';
  static const ADMIN_EDIT_USER = '/admin/users/edit';
  static const ADMIN_DEACTIVATE_USER = '/admin/users/deactivate';
  static const ADMIN_USER_SUCCESS = '/admin/users/success';

  static const PROFILE = '/profile';
  static const SETTINGS = '/settings';
  static const SETTINGS_NOTIFICATIONS = '/settings/notifications';
  static const SETTINGS_APPEARANCE = '/settings/appearance';
  static const SETTINGS_CHANGE_PASSWORD = '/settings/change-password';

  static const REQUESTOR = '/requestor';
  static const CREATE_REQUEST_TYPE = '/create-request/type';
  static const CREATE_REQUEST_DETAILS = '/create-request/details';
  static const CREATE_REQUEST_REVIEW = '/create-request/review';
  static const CREATE_REQUEST_SUCCESS = '/create-request/success';
  static const MY_REQUESTS = '/my-requests';
  static const REQUEST_DETAILS_READ = '/request-details-read';
  static const MONTHLY_SPENT = '/monthly-spent';
}
