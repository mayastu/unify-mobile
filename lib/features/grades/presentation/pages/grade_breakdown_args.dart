/// Passed as `extra` when navigating to [GradeBreakdownPage] — the
/// grades list only has these as strings (see [GradeCourseModel]),
/// so they're forwarded as-is instead of being re-fetched.
class GradeBreakdownArgs {
  final int courseId;
  final String courseName;
  final String courseCode;

  const GradeBreakdownArgs({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
  });
}
