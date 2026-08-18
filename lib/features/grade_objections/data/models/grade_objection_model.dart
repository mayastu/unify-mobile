class GradeObjectionPartyModel {
  final String id;
  final String name;

  const GradeObjectionPartyModel({required this.id, required this.name});

  factory GradeObjectionPartyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const GradeObjectionPartyModel(id: '', name: '');
    return GradeObjectionPartyModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
    );
  }
}

class GradeObjectionComponentModel {
  final String id;
  final String name;
  final double maxGrade;

  const GradeObjectionComponentModel({
    required this.id,
    required this.name,
    required this.maxGrade,
  });

  factory GradeObjectionComponentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GradeObjectionComponentModel(id: '', name: '', maxGrade: 0);
    }
    return GradeObjectionComponentModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
      maxGrade: _asDouble(json['max_grade']),
    );
  }
}

/// `GradeObjectionResource` — one objection submitted by the student
/// against a single graded component.
class GradeObjectionModel {
  final String id;
  final String attemptNo;
  final String status;
  final String details;
  final double? submittedGrade;
  final double? currentGrade;
  final double? resolvedGrade;
  final String responseNote;
  final bool resubmissionAllowed;
  final String studentGradeId;
  final String studentCourseId;
  final GradeObjectionPartyModel student;
  final GradeObjectionPartyModel course;
  final GradeObjectionComponentModel gradeComponent;

  /// Null until an instructor/admin has reviewed the objection.
  final GradeObjectionPartyModel? reviewedBy;
  final String submittedAt;
  final String resolvedAt;

  const GradeObjectionModel({
    required this.id,
    required this.attemptNo,
    required this.status,
    required this.details,
    required this.submittedGrade,
    required this.currentGrade,
    required this.resolvedGrade,
    required this.responseNote,
    required this.resubmissionAllowed,
    required this.studentGradeId,
    required this.studentCourseId,
    required this.student,
    required this.course,
    required this.gradeComponent,
    required this.reviewedBy,
    required this.submittedAt,
    required this.resolvedAt,
  });

  factory GradeObjectionModel.fromJson(Map<String, dynamic> json) {
    return GradeObjectionModel(
      id: _asString(json['id']),
      attemptNo: _asString(json['attempt_no']),
      status: _asString(json['status']),
      details: _asString(json['details']),
      submittedGrade: _asNullableDouble(json['submitted_grade']),
      currentGrade: _asNullableDouble(json['current_grade']),
      resolvedGrade: _asNullableDouble(json['resolved_grade']),
      responseNote: _asString(json['response_note']),
      resubmissionAllowed: json['resubmission_allowed'] == true,
      studentGradeId: _asString(json['student_grade_id']),
      studentCourseId: _asString(json['student_course_id']),
      student: GradeObjectionPartyModel.fromJson(json['student']),
      course: GradeObjectionPartyModel.fromJson(json['course']),
      gradeComponent: GradeObjectionComponentModel.fromJson(json['grade_component']),
      reviewedBy: json['reviewed_by'] == null
          ? null
          : GradeObjectionPartyModel.fromJson(json['reviewed_by']),
      submittedAt: _asString(json['submitted_at']),
      resolvedAt: _asString(json['resolved_at']),
    );
  }
}

/// One page of `/my-grade-objections`.
class GradeObjectionPageResult {
  final List<GradeObjectionModel> items;
  final int currentPage;
  final int lastPage;

  const GradeObjectionPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });
}

String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  return _asDouble(value);
}
