class GradeSemesterModel {
  final String id;
  final String name;

  const GradeSemesterModel({
    required this.id,
    required this.name,
  });

  factory GradeSemesterModel.fromJson(Map<String, dynamic> json) {
    return GradeSemesterModel(
      id: _asString(json['id']),
      name: _asString(json['name']),
    );
  }
}

/// One component's score within a course, e.g. Midterm 22/30.
/// Nested inside GradeCourseModel — comes from the *same* response
/// as the course itself (no separate request needed).
class GradeComponentScoreModel {
  final int gradeComponentId;
  final String componentName;
  final double maxGrade;
  final double grade;

  const GradeComponentScoreModel({
    required this.gradeComponentId,
    required this.componentName,
    required this.maxGrade,
    required this.grade,
  });

  factory GradeComponentScoreModel.fromJson(Map<String, dynamic> json) {
    return GradeComponentScoreModel(
      gradeComponentId: _asInt(json['grade_component_id']),
      componentName: _asString(json['component_name']),
      maxGrade: _asDouble(json['max_grade']),
      grade: _asDouble(json['grade']),
    );
  }
}

class GradeCourseModel {
  final String studentCourseId;
  final String courseId;
  final String courseName;
  final String courseCode;
  final String creditHours;
  final String attemptNo;
  final String finalGrade;
  final String gpaPoint;
  final String letter;
  final String status;
  final List<GradeComponentScoreModel> grades;

  const GradeCourseModel({
    required this.studentCourseId,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.creditHours,
    required this.attemptNo,
    required this.finalGrade,
    required this.gpaPoint,
    required this.letter,
    required this.status,
    required this.grades,
  });

  factory GradeCourseModel.fromJson(Map<String, dynamic> json) {
    return GradeCourseModel(
      studentCourseId: _asString(json['student_course_id']),
      courseId: _asString(json['course_id']),
      courseName: _asString(json['course_name']),
      courseCode: _asString(json['course_code']),
      creditHours: _asString(json['credit_hours']),
      attemptNo: _asString(json['attempt_no']),
      finalGrade: _asString(json['final_grade']),
      gpaPoint: _asString(json['gpa_point']),
      letter: _asString(json['letter']),
      status: _asString(json['status']),
      grades: (json['grades'] as List? ?? [])
          .map((e) => GradeComponentScoreModel.fromJson(e))
          .toList(),
    );
  }
}

class CurrentSemesterGradesModel {
  final GradeSemesterModel semester;
  final String gpa;
  final String earnedCreditHours;
  final String failedCreditHours;
  final String registeredCreditHours;
  final List<GradeCourseModel> courses;

  const CurrentSemesterGradesModel({
    required this.semester,
    required this.gpa,
    required this.earnedCreditHours,
    required this.failedCreditHours,
    required this.registeredCreditHours,
    required this.courses,
  });

  factory CurrentSemesterGradesModel.fromJson(Map<String, dynamic> json) {
    return CurrentSemesterGradesModel(
      semester: GradeSemesterModel.fromJson(json['semester']),
      gpa: _asString(json['gpa']),
      earnedCreditHours: _asString(json['earned_credit_hours']),
      failedCreditHours: _asString(json['failed_credit_hours']),
      registeredCreditHours: _asString(json['registered_credit_hours']),
      courses: (json['courses'] as List)
          .map((e) => GradeCourseModel.fromJson(e))
          .toList(),
    );
  }
}

/// The docs describe these fields as strings, but the live server
/// sometimes returns raw numbers (e.g. `0` instead of `"0"`).
/// Accept either and normalize to String.
String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
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
