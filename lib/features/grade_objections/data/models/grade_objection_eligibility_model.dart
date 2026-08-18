/// Result of `GET /student-grades/{studentGrade}/objection-eligibility`.
/// Tells the UI whether to show the objection form, and if not, why.
class GradeObjectionEligibilityModel {
  final bool canSubmit;

  /// One of 'resubmission_not_allowed' / 'pending_objection_exists' /
  /// 'course_objections_disabled', or null when [canSubmit] is true.
  final String? reason;
  final bool courseObjectionsEnabled;
  final int studentGradeId;
  final String? latestObjectionId;
  final String? latestObjectionStatus;
  final bool resubmissionAllowed;

  const GradeObjectionEligibilityModel({
    required this.canSubmit,
    required this.reason,
    required this.courseObjectionsEnabled,
    required this.studentGradeId,
    required this.latestObjectionId,
    required this.latestObjectionStatus,
    required this.resubmissionAllowed,
  });

  factory GradeObjectionEligibilityModel.fromJson(Map<String, dynamic> json) {
    return GradeObjectionEligibilityModel(
      canSubmit: json['can_submit'] == true,
      reason: _asNullableString(json['reason']),
      courseObjectionsEnabled: json['course_objections_enabled'] == true,
      studentGradeId: _asInt(json['student_grade_id']),
      latestObjectionId: _asNullableString(json['latest_objection_id']),
      latestObjectionStatus: _asNullableString(json['latest_objection_status']),
      resubmissionAllowed: json['resubmission_allowed'] == true,
    );
  }

  /// Human-readable explanation for why the student can't submit right
  /// now. Null when [canSubmit] is true (nothing to explain).
  String? get reasonMessage {
    switch (reason) {
      case 'resubmission_not_allowed':
        return 'Resubmission is not allowed for this grade.';
      case 'pending_objection_exists':
        return 'You already have a pending objection for this grade.';
      case 'course_objections_disabled':
        return 'Objections are currently disabled for this course.';
      default:
        return null;
    }
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String? _asNullableString(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  return s.isEmpty ? null : s;
}
