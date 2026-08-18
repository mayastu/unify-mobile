import '../models/attendance_summary_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceSummaryModel> getAttendanceSummary(int studentCourseId);
}
