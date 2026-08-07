class EndPoints{
  const EndPoints._();
  static const String baseUrl = 'http://192.168.1.113:8000/api';
  static const String login="/login";
  static const String logout = '/logout';
  static const String forgotPassword = '/forgot-password';
  static const String verifyOtp = '/verify-otp';
  static const String resetPassword = '/reset-password';
  static const String getProfile = "/students/profile";
  static const String semesters = "/semesters";
  static const String payments = "/payments";
  static const String financialAccount = "/financialaccounts";
  static const String hourPurchases = "/hourpurchases";
  static const String courses = "/courses";
  static const String courseSections = "/coursesections";
  static const String registration = "/registration";
  static const String availableCourses = "$registration/available-courses";
  static const String registerCourses = "$registration/register";
  // Path parameter + "/withdraw" is appended by the data source.
  static const String withdrawCourse = registration;
  static const String classrooms = "/classrooms";
  static const String studentSchedules = "/studentschedules";

}