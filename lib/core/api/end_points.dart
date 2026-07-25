class EndPoints{
  const EndPoints._();
  static const String baseUrl = 'http://10.2.0.2:8000/api';

  static const String login="/login";
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
}