import '../models/schedule_entry_model.dart';

abstract class StudentScheduleRemoteDataSource {
  /// Always returns all 7 days, empty lists for days with no classes.
  Future<Map<String, List<ScheduleEntryModel>>> getStudentSchedule();
}
