import 'student_schedule_repository.dart';
import '../data_source/student_schedule_remote_datasource.dart';
import '../models/schedule_entry_model.dart';

class StudentScheduleRepositoryImpl implements StudentScheduleRepository {
  final StudentScheduleRemoteDataSource remote;

  StudentScheduleRepositoryImpl(this.remote);

  @override
  Future<Map<String, List<ScheduleEntryModel>>> getStudentSchedule() {
    return remote.getStudentSchedule();
  }
}
