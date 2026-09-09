class EndPoints{
  const EndPoints._();
  static const String baseUrl = 'http://10.18.230.96:8000/api';
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
  static const String studentCourses = "/studentcourses";
  static const String classrooms = "/classrooms";
  static const String studentSchedules = "/studentschedules";
  static const String currentSemesterGrades = "/currentsemestergrades";

  // Student-facing read-only attendance summary for one enrollment.
  static String studentCourseAttendance(int studentCourseId) =>
      "/studentcourses/$studentCourseId/attendance";

  // Per-course grade breakdown (grade components + the logged-in
  // student's score in each one). `sectionType` must be one of
  // "theory" / "practical" / "project".
  static String studentGrades(int courseId, String sectionType) =>
      "/courses/$courseId/$sectionType/student-grades";

  // Whether the logged-in student can currently object to one
  // specific graded entry (path param is the `id` from a
  // StudentGradeItem, not a course id).
  static String objectionEligibility(int studentGradeId) =>
      "/student-grades/$studentGradeId/objection-eligibility";
  static const String gradeObjections = "/grade-objections";
  static const String myGradeObjections = "/my-grade-objections";
  static String gradeObjection(int id) => "$gradeObjections/$id";

  // Materials uploaded by the instructor for one course section.
  static String courseSectionMaterials(int courseSectionId) =>
      "/course-sections/$courseSectionId/materials";


  static const String notifications = "/notifications";
  static const String notificationsUnreadCount = "$notifications/unread-count";
  static const String notificationsReadAll = "$notifications/read-all";
// Path parameter + "/read" appended by the data source for markAsRead.

  static const String deviceTokens = "/device-tokens";

  static const String announcements = "/announcements";

  static const String systemSettings = "/systemsettings";

}