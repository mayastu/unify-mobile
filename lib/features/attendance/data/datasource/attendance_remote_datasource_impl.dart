import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/attendance_summary_model.dart';
import 'attendance_remote_datasource.dart';

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final ApiConsumer api;

  AttendanceRemoteDataSourceImpl(this.api);

  @override
  Future<AttendanceSummaryModel> getAttendanceSummary(
    int studentCourseId,
  ) async {
    final response = await api.get(
      EndPoints.studentCourseAttendance(studentCourseId),
    );

    final Map<String, dynamic> data = response["data"];

    return AttendanceSummaryModel.fromJson(data);
  }
}
