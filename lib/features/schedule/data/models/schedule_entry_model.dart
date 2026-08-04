import '../../../classrooms/data/models/classroom_model.dart';
import '../../../course_sections/data/models/course_section_model.dart';

class ScheduleEntryModel {
  final int id;
  final CourseSectionModel courseSection;
  final ClassroomModel classroom;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String createdAt;

  const ScheduleEntryModel({
    required this.id,
    required this.courseSection,
    required this.classroom,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  /// [dayOverride] is the day key this entry was nested under in the
  /// `/studentschedules` response, used as a fallback since individual
  /// entries may omit `day_of_week` (it's already implied by the key).
  factory ScheduleEntryModel.fromJson(
    Map<String, dynamic> json, {
    required String dayOverride,
  }) {
    return ScheduleEntryModel(
      id: json['id'],
      courseSection: CourseSectionModel.fromJson(json['course_section']),
      classroom: ClassroomModel.fromJson(json['classroom']),
      dayOfWeek: json['day_of_week'] ?? dayOverride,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  /// "09:00:00" -> "09:00"
  String get displayStartTime => _trimSeconds(startTime);
  String get displayEndTime => _trimSeconds(endTime);

  static String _trimSeconds(String time) {
    final parts = time.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return time;
  }
}
