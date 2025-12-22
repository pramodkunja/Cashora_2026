

class AppText {
  // Common
  static const String appName = 'Cash App';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String loading = 'Loading...';
  // Common placeholders
  static const String comingSoon = 'Coming Soon';
  static const String profileUnderConstruction = 'Profile screen is under construction';

  // Auth
  static const String welcomeBack = 'Welcome Back';
  static const String signInSubtitle = 'Sign in to manage your expenses';
  static const String emailAddress = 'Email Address';
  static const String enterEmail = 'Enter your email';
  static const String password = 'Password';
  static const String enterPassword = 'Enter your password';
  static const String forgotPassword = 'Forgot Password?'; // As link
  static const String forgotPasswordTitle = 'Forgot Password?'; // As title
  static const String forgotPasswordSubtitle = 'No worries! Enter your email or phone number linked with your account.';
  static const String emailOrPhone = 'Email or Phone';
  static const String enterEmailOrPhone = 'Enter email or phone';
  static const String sendCode = 'Send Code';
  static const String signIn = 'Sign In';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUp = 'Sign Up';
  
  // Requestor Dashboard
  static const String helloUser = 'Hello, Alex'; // TODO: Dynamic name
  static const String newRequest = 'New Request';
  static const String monthlyExpense = 'Monthly Expense';
  static const String viewDetails = 'View Details';
  static const String spent = 'Spent';
  static const String limit = 'Limit';
  static const String pendingApprovals = 'Pending Approvals';
  static const String requestsWaiting = 'Requests waiting'; // Dynamic number?
  static const String recentRequests = 'Recent Requests';
  
  // My Requests
  static const String myRequests = 'My Requests';
  static const String searchRequests = 'Search requests...';
  static const String all = 'All';
  static const String pending = 'Pending';
  static const String approved = 'Approved';
  static const String rejected = 'Rejected';
  
  // Create Request
  static const String selectRequestType = 'Select Request Type';
  static const String requestDetails = 'Request Details';
  static const String amount = 'Amount';
  static const String category = 'Category';
  static const String selectCategory = 'Select Category';
  static const String purpose = 'Purpose';
  static const String purposeHint = 'e.g., Office Supplies';
  static const String attachments = 'Attachments';
  static const String takePhoto = 'Take Photo';
  static const String uploadBill = 'Upload Bill';
  static const String reviewRequest = 'Review Request';
  static const String reviewYourRequest = 'Review your request details';
  static const String submitRequest = 'Submit Request';
  static const String requestSubmitted = 'Request Submitted';
  static const String requestApproved = 'Request Automatically Approved';
  static const String fundsAdded = 'Funds have been added to your wallet';
  static const String requestSubmittedDesc = 'Your request has been submitted successfully.';
  static const String goToDashboard = 'Go to Dashboard';
  
  // Monthly Spent
  static const String monthlySpentTransactions = 'Monthly Spent Transactions';
  static const String totalSpent = 'Total Spent';
  static const String searchTransactions = 'Search transactions...';
  static const String applyFilter = 'Apply Filter';
  // Reset Password
  static const String resetPassword = "Reset Password";
  static const String createNewPassword = "Create New Password";
  static const String newPasswordMustBeDifferent = "Your new password must be different from previously used passwords.";
  static const String newPassword = "New Password";
  static const String confirmPassword = "Confirm Password";
  static const String enterNewPassword = "Enter new password";
  static const String confirmNewPassword = "Confirm new password";
  static const String updatePassword = "Update Password";
  static const String passwordUpdatedSuccess = "Your password has been updated successfully.";

  static const String backToLogin = "Back to Login";

  // Organization Setup
  static const String setupOrganization = "Setup Organization";
  static const String organizationDetails = "ORGANIZATION DETAILS";
  static const String organizationName = "Organization Name";
  static const String organizationCode = "Organization Code";
  static const String adminDetails = "ADMIN DETAILS";
  static const String fullName = "Full Name";
  static const String workEmail = "Work Email";
  static const String adminCredentialsInfo = "Admin credentials will be sent to the registered email address securely.";
  static const String secureSSL = "256-bit SSL Secure";
  static const String createOrganizationAction = "Create Organization & Admin";
  static const String organizationCreatedSuccess = "Organization created successfully";
  static const String secureWorkspaceReady = "Your secure workspace is ready. Admin credentials have been sent to your email.";
  static const String checkInbox = "Check your inbox";
  static const String checkInboxDesc = "Please check your inbox and spam folder to retrieve your temporary password.";
  static const String contactSupport = "Contact Support";
  static const String didntReceiveEmail = "Didn't receive an email?";

  // Placeholders & Inputs
  static const String emailPlaceholder = 'name@company.com';
  static const String passwordPlaceholder = '••••••••';
  
  // Navigation
  static const String dashboard = 'Dashboard';
  static const String requests = 'Requests';
  static const String profile = 'Profile';
  
  // Enterprise Setup
  static const String enterpriseSetup = 'ENTERPRISE SETUP';
  static const String setUpOrganization = 'Set up organization';

  // Request Details & Status
  static const String date = 'Date';
  static const String description = 'Description';
  static const String noDescription = 'No description provided.';
  static const String noAttachments = 'No attachments';
  
  static const String statusPending = 'Pending';
  static const String statusApproved = 'Approved';
  static const String statusRejected = 'Rejected';
  static const String statusPaid = 'Paid';
  
  static const String filterAll = 'All';
  static const String filterPaid = 'Paid';
  static const String filterPending = 'Pending';
  static const String filterApproved = 'Approved';
  static const String filterRejected = 'Rejected';
  static const String totalAmount = 'TOTAL AMOUNT';
  static const String requestId = 'Request ID';
  static const String status = 'Status';
  static const String paymentStatus = 'Payment Status';
  
  static const String approvedSC = 'APPROVED'; // Small Caps Style or Uppercase
  static const String pendingSC = 'PENDING';
  // Select Request Type
  static const String approvalTime = 'Approval Time';
  static const String preApproved = 'Pre-approved';
  static const String preApprovedDesc = 'For expenses approved before purchase.';
  static const String postApproved = 'Post-approved';
  static const String postApprovedDesc = 'For expenses needing approval after purchase.';

  // Request Details (Form)
  static const String requestType = 'Request Type';
  static const String approvalRequired = 'Approval Required';
  static const String approvalRequiredDesc = 'Amount exceeds auto-approval limit';
  static const String descriptionOptional = 'Description (Optional)';
  static const String descriptionPlaceholder = 'e.g., A4 paper and pens from Staples';
  
  // Review Request
  static const String totalRequestedAmount = 'Total Requested Amount';
  static const String notSelected = 'Not Selected';

  // Forgot Password & OTP
  static const String rememberPassword = 'Remember your password? ';
  static const String logIn = 'Log In';
  static const String otpVerification = 'OTP Verification';
  static const String enterConfirmationCode = 'Enter confirmation code';
  static const String otpSentMessage = "We've sent a 6-digit verification code to the phone number ending in ••••1234."; // TODO: Make dynamic
  static const String resend = 'Resend';
  static const String resendCodeIn = 'Resend code in';
  static const String verify = 'Verify';
  static const String didntReceiveCode = "Didn't receive the code? ";
  
  // Organization Setup Hints & Labels
  static const String stepperOrganization = 'Organization';
  static const String stepperPreferences = 'Preferences';
  static const String hintOrgName = 'e.g. Acme Corp';
  static const String hintAdminName = 'First Last';
  static const String hintAdminEmail = 'admin@company.com';
  static const String goToLogin = 'Go to Login';

  // Admin Module
  static const String welcomeApprover = 'Welcome back,\nApprover!';
  static const String overview = 'Overview';
  static const String actions = 'Actions';
  static const String reviewPending = 'Review Pending';
  static const String viewAllRequests = 'View all requests';
  static const String viewallRequests = 'View all requests';
  static const String viewHistory = 'View History';
  static const String pastApprovals = 'Past approvals';
  static const String addNewUser = 'Add New User';
  static const String createNewAccount = 'Create new account';
  
  static const String approvalsTitle = 'Approvals';
  static const String from = 'From:';
  
  static const String clientLunchMeeting = 'Client Lunch Meeting';
  static const String businessMeal = 'Business Meal';
  static const String pendingApproval = 'Pending Approval';
  static const String attachedBill = 'Attached Bill';
  static const String tapToView = 'Tap to view';
  static const String askClarification = 'Ask Clarification';
  static const String approve = 'Approve';
  static const String reject = 'Reject';
  
  static const String approvedSuccessTitle = 'Approved!';
  static const String approvedSuccessDesc = 'The petty cash request has been successfully approved. The requester will be notified.';
  static const String backToApprovals = 'Back to Approvals List';

  // Admin Tabs
  static const String tabPending = 'Pending';
  static const String tabApproved = 'Approved';
  static const String tabRejected = 'Rejected';

  // Bottom Bar (if specialized)
  static const String navHome = 'Home';
  static const String navApprovals = 'Approvals';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';

  // Admin Rejection & Clarification
  static const String reasonForRejection = 'Reason for Rejection';
  static const String rejectionReasonHint = 'Please provide a reason for rejecting this request.';
  static const String reasonLabel = 'Reason';
  static const String reasonPlaceholder = 'e.g., Missing receipt, incorrect amount...';
  static const String confirmReject = 'Confirm Reject';
  static const String requestRejected = 'Request Rejected';
  static const String requestRejectedDesc = 'You have successfully rejected this petty cash request.';
  static const String sentBackSuccessfully = 'Sent Back Successfully';
  static const String sentBackDesc = 'The petty cash request has been returned for more information.';
  static const String backToApprovalsList = 'Back to Approvals List';
  static const String askClarificationTitle = 'Ask for Clarification';
  static const String yourQuestions = 'Your Questions or Comments';
  static const String clarificationHint = 'Please provide more details or attach the missing invoice.';
  static const String sendBackForClarification = 'Send Back for Clarification';
  static const String pastApprovalsTitle = 'Past Approvals';
  static const String clarified = 'Clarified';
  static const String clarification = 'Clarification';
  static const String confirmation = 'Confirmation';

  // History Details
  static const String approvalTimeline = 'Approval Timeline';
  static const String billAndAttachments = 'Bill & Attachments';
  static const String submittedOn = 'SUBMITTED ON';
  static const String actionDate = 'ACTION DATE';
  static const String approvedByYou = 'Approved by You';
  static const String pendingApprovalStatus = 'Pending Approval'; // statusPending duplicates
  static const String requestSubmittedStatus = 'Request Submitted';

  // Clarification Status
  static const String clarificationStatusTitle = 'Clarification Status';
  static const String currentStatus = 'Current Status';
  static const String responseReceived = 'Response Received';
  static const String waitingForRequestor = 'Waiting for requestor to reply';
  static const String pendingResponse = 'Pending Response';
  static const String reviewResponseAction = 'Review the response below to take action';
  static const String yourClarificationRequest = 'Your Clarification Request';
  static const String sentByYou = 'SENT BY YOU';
  static const String requestorsResponse = 'Requestor\'s Response';
  static const String waitingForResponsePlaceholder = 'Waiting for John Doe to respond...';
  static const String responseNotification = 'You will be notified when a response is submitted.';
  static const String itemizedReceipt = 'itemized_receipt_001.pdf';
  static const String askClarificationAgain = 'Ask Clarification Again';
  static const String clarificationHistory = 'Clarification History';
  static const String youAsked = 'YOU ASKED';
  static const String responseReceivedTitle = 'Response Received'; // Reusing or new
  static const String furtherClarificationNeeded = 'Further Clarification Needed';
  static const String sendClarificationRequest = 'Send Clarification Request';
  static const String makeItClear = 'Make it clear';
  static const String explainWhy = 'Explain why the response is still insufficient...';

  // Profile & Settings
  static const String myProfile = 'My Profile';
  static const String edit = 'Edit';
  static const String phone = 'Phone';
  static const String role = 'Role';
  static const String changePassword = 'Change Password';
  static const String appSettings = 'App Settings';
  static const String logOut = 'Log Out';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';
  static const String currency = 'Currency';
  static const String appearance = 'Appearance';
  static const String faceIdTouchId = 'Face ID / Touch ID';
  static const String helpSupport = 'Help & Support';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';

  // User Management
  static const String addNewUserTitle = 'Add New User';
  static const String enterFullName = 'Enter full name';
  static const String selectRole = 'Select Role';
  static const String uploadPhoto = 'Upload Photo';
  static const String editPhoto = 'Edit Photo';
  static const String delete = 'Delete';
  static const String editUser = 'Edit User';
  static const String activeStatus = 'Active Status';
  static const String userCanAccessSystem = 'User can access the system';
  static const String allowCashAdvances = 'Allow Cash Advances';
  static const String enablePettyCashRequests = 'Enable petty cash requests';
  static const String viewGlobalReports = 'View Global Reports';
  static const String readOnlyAccess = 'Read-only access to analytics';
  static const String updateUser = 'Update User';
  static const String createUser = 'Create User';
  static const String permissions = 'Permissions';

  // Deactivation
  static const String deactivateAccount = 'Deactivate Account?';
  static const String deactivateDesc = 'You are about to deactivate access for the following user. They will no longer be able to submit or approve petty cash requests.';
  static const String understandAction = 'I understand this action cannot be undone immediately without admin approval.';
  static const String deactivateUser = 'Deactivate User';
  static const String userDeactivatedSuccess = 'User Deactivated';
  static const String userDeactivatedDesc = 'The user has been successfully deactivated.';
  static const String userCreatedSuccess = 'User Created Successfully';
  static const String userCreatedDesc = 'The new user account has been created.';
  static const String userUpdatedSuccess = 'User Updated Successfully';
  static const String userUpdatedDesc = 'The user details have been updated.';
  static const String backToUserList = 'Back to User List';
  static const String employeeId = 'Employee ID: #8834'; // Mock
  static const String active = 'Active';

  // Enhanced User List
  static const String manageUsers = 'Manage Users';
  static const String searchUsersHint = 'Search name, email...';
  static const String allUsers = 'ALL USERS';
  static const String exportList = 'Export List';
  static const String viewProfile = 'View Profile';

  // Enhanced Success Screen
  static const String goToManageUsers = 'Go to Manage Users';
  static const String addAnotherUser = 'Add Another User';
  static const String userCreatedSuccessTitle = 'User Created Successfully';
  static const String userCreatedSuccessDesc = 'The new account has been set up and is ready to use.';
  static const String createdOn = 'Created On';

  // Settings - Notifications
  static const String approvalStatusUpdates = 'Approval Status Updates';
  static const String approvalStatusDesc = 'Get notified when a request is approved or rejected';
  static const String newRequestSubmitted = 'New Request Submitted';
  static const String newRequestDesc = 'Receive alerts when team members submit requests';
  static const String paymentReminders = 'Payment Reminders';
  static const String paymentRemindersDesc = 'Reminders for pending payouts and upcoming dues';
  static const String clarificationRequests = 'Clarification Requests';
  static const String clarificationRequestsDesc = 'Notify when additional information is required';

  // Settings - Appearance
  static const String appTheme = 'APP THEME';
  static const String lightTheme = 'Light Theme';
  static const String darkTheme = 'Dark Theme';
  static const String systemDefault = 'System Default';
  static const String textSize = 'TEXT SIZE';
  static const String small = 'Small';
  static const String medium = 'Medium';
  static const String large = 'Large';
  static const String preview = 'PREVIEW';
  static const String officeSupplies = 'Office Supplies';
  static const String todayTime = 'Today, 10:23 AM';
  static const String previewDesc = 'This is how your transaction items will look with the current settings applied.';
  static const String saveChanges = 'Save Changes';

  // Settings - Change Password
  static const String currentPassword = 'Current Password';
  static const String enterCurrentPassword = 'Enter current password';
  // static const String newPassword = 'New Password'; // Existing
  // static const String enterNewPassword = 'Enter new password'; // Existing
  // static const String confirmNewPassword = 'Confirm New Password'; // Existing
  static const String reEnterNewPassword = 'Re-enter new password';
  static const String mustBeAtLeast8Chars = 'Must be at least 8 characters';
  static const String bothPasswordsMatch = 'Both passwords must match';
  // static const String updatePassword = 'Update Password'; // Existing
  static const String forgotPasswordQuestion = 'Forgot Password?';
}
