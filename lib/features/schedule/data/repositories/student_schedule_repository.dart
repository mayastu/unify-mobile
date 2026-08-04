import '../models/schedule_entry_model.dart';

abstract class StudentScheduleRepository {
  Future<Map<String, List<ScheduleEntryModel>>> getStudentSchedule();
}
