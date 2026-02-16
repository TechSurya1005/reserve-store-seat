import 'dart:ui';

class AppKeys {
  // ------------------------------------------------------------
  // 🔐 Shared Preferences: User & Auth Keys
  // ------------------------------------------------------------
  static const String appTheme = "appTheme";
  static const Brightness appThemeValue = Brightness.dark;
  static const String deviceToken = "affiliateapp_device_token";

  // ------------------------------------------------------------
  // 🔐 Shared Preferences: User & Auth Keys
  // ------------------------------------------------------------
  static const String userLoginToken = 'user_login_token';
  static const String dealerJson = 'dealer_json';
  static const String countryCode = 'country_code';
  static const String isLoggedIn = 'is_affiliateapp_logged_in';
  static const String isGuestMode = 'is_affiliateapp_guest_mode';

  // ------------------------------------------------------------
  // 🏪 Shared Preferences: User Data Keys
  // ------------------------------------------------------------

  static const String userId = 'user_id';
  static const String userAuthUid = 'user_auth_uid';
  static const String userEmail = 'user_email';
  static const String userPhone = 'user_phone';
  static const String userPasswordHash = 'user_password_hash';
  static const String userFirstName = 'user_first_name';
  static const String userLastName = 'user_last_name';
  static const String userFullName = 'user_full_name';
  static const String username = 'user_username';
  static const String userTimezone = 'user_timezone';
  static const String userAddressLine1 = 'user_address_line1';
  static const String userCity = 'user_city';
  static const String userState = 'user_state';
  static const String userPostalCode = 'user_postal_code';
  static const String userAvatarUrl = 'user_avatar_url';
  static const String userCoverUrl = 'user_cover_url';
  static const String userBio = 'user_bio';
  static const String userIsEmailVerified = 'user_is_email_verified';
  static const String userIsPhoneVerified = 'user_is_phone_verified';
  static const String userIsActive = 'user_is_active';
  static const String userIsBlocked = 'user_is_blocked';
  static const String userStatus = 'user_status';
  static const String userLastLoginAt = 'user_last_login_at';
  static const String userLoginIp = 'user_login_ip';
  static const String userUserAgent = 'user_user_agent';
  static const String userRole = 'user_role';
  static const String userPermissions = 'user_permissions';
  static const String userPreferences = 'user_preferences';
  static const String userDob = 'user_dob';
  static const String userGender = 'user_gender';
  static const String userNationalId = 'user_national_id';
  static const String userKycVerified = 'user_kyc_verified';
  static const String userTwoFactorEnabled = 'user_two_factor_enabled';
  static const String userPasswordChangedAt = 'user_password_changed_at';
  static const String userFailedLoginAttempts = 'user_failed_login_attempts';
  static const String userCreatedAt = 'user_created_at';
  static const String userUpdatedAt = 'user_updated_at';
}
