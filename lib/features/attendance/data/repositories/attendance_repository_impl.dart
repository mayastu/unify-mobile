import '../datasource/attendance_remote_datasource.dart';
import '../models/attendance_summary_model.dart';
import 'attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remote;

  AttendanceRepositoryImpl(this.remote);

  @override
  Future<AttendanceSummaryModel> getAttendanceSummary(int studentCourseId) {
    return remote.getAttendanceSummary(studentCourseId);
  }
}
