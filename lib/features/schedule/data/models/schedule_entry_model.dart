import '../../../classrooms/data/models/classroom_model.dart';

class ScheduleCourseModel {
  final int id;
  final String name;
  final String courseCode;

  const ScheduleCourseModel({
    required this.id,
    required this.name,
    required this.courseCode,
  });

  factory ScheduleCourseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleCourseModel(
      id: json['id'],
      name: json['name'] ?? '',
      courseCode: json['course_code'] ?? '',
    );
  }
}

class ScheduleInstructorModel {
  final int id;
  final String? name;

  const ScheduleInstructorModel({
    required this.id,
    this.name,
  });

  factory ScheduleInstructorModel.fromJson(Map<String, dynamic> json) {
    return ScheduleInstructorModel(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ScheduleEntryModel {
  final ScheduleCourseModel course;
  final String sectionType;
  final String startTime;
  final String endTime;
  final ClassroomModel classroom;
  final ScheduleInstructorModel? instructor;
  final String dayOfWeek;

  const ScheduleEntryModel({
    required this.course,
    required this.sectionType,
    required this.startTime,
    required this.endTime,
    required this.classroom,
    this.instructor,
    required this.dayOfWeek,
  });

  /// [dayOverride] is the day key this entry was nested under in the
  /// `/studentschedules` response (e.g. "Monday"). The API doesn't
  /// repeat the day inside each entry there, so we fall back to the
  /// parent key.
  factory ScheduleEntryModel.fromJson(
      Map<String, dynamic> json, {
        required String dayOverride,
      }) {
    return ScheduleEntryModel(
      course: ScheduleCourseModel.fromJson(
        json['course'] as Map<String, dynamic>? ?? const {},
      ),
      sectionType: json['section_type'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      // Reused as-is: ClassroomModel already falls back safely on the
      // fields this endpoint omits (building, floor, capacity, created_at).
      classroom: ClassroomModel.fromJson(
        json['classroom'] as Map<String, dynamic>? ?? const {},
      ),
      instructor: json['instructor'] == null
          ? null
          : ScheduleInstructorModel.fromJson(json['instructor']),
      dayOfWeek: json['day_of_week'] ?? dayOverride,
    );
  }

  String get displaySectionType {
    switch (sectionType) {
      case 'theory':
        return 'Theory';
      case 'practical':
        return 'Practical';
      default:
        return sectionType;
    }
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