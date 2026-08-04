import 'student_schedule_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/schedule_entry_model.dart';

class StudentScheduleRemoteDataSourceImpl
    implements StudentScheduleRemoteDataSource {
  final ApiConsumer api;

  StudentScheduleRemoteDataSourceImpl(this.api);

  static const List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Future<Map<String, List<ScheduleEntryModel>>> getStudentSchedule() async {
    final response = await api.get(
      EndPoints.studentSchedules,
    );

    final schedule = <String, List<ScheduleEntryModel>>{
      for (final day in weekDays) day: <ScheduleEntryModel>[],
    };

    final rawData = response["data"];

    // The backend has been seen to return `data: [null]` instead of the
    // day-keyed object (looks like a bug on an empty schedule). Fall
    // back to an all-empty week rather than crashing on it.
    if (rawData is Map) {
      rawData.forEach((day, entries) {
        if (entries is List) {
          schedule[day.toString()] = entries
              .whereType<Map<String, dynamic>>()
              .map(
                (e) => ScheduleEntryModel.fromJson(
                  e,
                  dayOverride: day.toString(),
                ),
              )
              .toList();
        }
      });
    }

    return schedule;
  }
}
