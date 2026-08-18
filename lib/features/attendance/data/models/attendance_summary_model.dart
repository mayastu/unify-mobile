/// One past session's attendance record within a course, as returned
/// inside `sessions`. The docs type `sessions` as a bare `string`,
/// which is the same generic-schema quirk seen elsewhere in this API
/// (e.g. `grades` on GradeCourseModel) — the live server actually
/// returns a list once real session data exists. Field names below
/// are a best guess pending a real non-empty response; adjust here
/// only if they turn out different, nothing else depends on the
/// exact key names.
class AttendanceSessionEntryModel {
  final int id;
  final String sessionDate;
  final String status;

  const AttendanceSessionEntryModel({
    required this.id,
    required this.sessionDate,
    required this.status,
  });

  factory AttendanceSessionEntryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionEntryModel(
      id: _asInt(json['id']),
      sessionDate:
          (json['session_date'] ?? json['date'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }
}

/// `GET /studentcourses/{studentCourseId}/attendance` — a student's
/// attendance standing for one enrollment.
class AttendanceSummaryModel {
  final int studentCourseId;
  final int presentSessions;
  final int absentSessions;
  final double attendancePercentage;
  final int maxAbsences;
  final int? remainingAbsences;

  /// One of "good", "warning", "denied" — denied means the max
  /// allowed absences has been exceeded (commonly: barred from the
  /// final exam per university policy).
  final String attendanceStatus;

  final List<AttendanceSessionEntryModel> sessions;

  const AttendanceSummaryModel({
    required this.studentCourseId,
    required this.presentSessions,
    required this.absentSessions,
    required this.attendancePercentage,
    required this.maxAbsences,
    required this.remainingAbsences,
    required this.attendanceStatus,
    required this.sessions,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      studentCourseId: _asInt(json['student_course_id']),
      presentSessions: _asInt(json['present_sessions']),
      absentSessions: _asInt(json['absent_sessions']),
      attendancePercentage: _asDouble(json['attendance_percentage']),
      maxAbsences: _asInt(json['max_absences']),
      remainingAbsences: json['remaining_absences'] == null
          ? null
          : _asInt(json['remaining_absences']),
      attendanceStatus: json['attendance_status']?.toString() ?? '',
      sessions: (json['sessions'] is List)
          ? (json['sessions'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => AttendanceSessionEntryModel.fromJson(e))
              .toList()
          : const [],
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
