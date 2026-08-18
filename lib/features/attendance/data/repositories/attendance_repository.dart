import '../models/attendance_summary_model.dart';

abstract class AttendanceRepository {
  Future<AttendanceSummaryModel> getAttendanceSummary(int studentCourseId);
}
