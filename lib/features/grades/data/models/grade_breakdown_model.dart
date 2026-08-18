/// One row of a course's grading scheme, e.g. "Midterm" out of 30.
class GradeComponentModel {
  final int id;
  final int courseId;
  final String name;
  final double maxGrade;
  final int displayOrder;
  final String sectionType;

  const GradeComponentModel({
    required this.id,
    required this.courseId,
    required this.name,
    required this.maxGrade,
    required this.displayOrder,
    required this.sectionType,
  });

  factory GradeComponentModel.fromJson(Map<String, dynamic> json) {
    return GradeComponentModel(
      id: _asInt(json['id']),
      courseId: _asInt(json['course_id']),
      name: json['name']?.toString() ?? '',
      maxGrade: _asDouble(json['max_grade']),
      displayOrder: _asInt(json['display_order']),
      sectionType: json['section_type']?.toString() ?? '',
    );
  }
}

/// The logged-in student's score for a single [GradeComponentModel].
class StudentGradeItemModel {
  final int id;
  final GradeComponentModel component;
  final double grade;

  const StudentGradeItemModel({
    required this.id,
    required this.component,
    required this.grade,
  });

  factory StudentGradeItemModel.fromJson(Map<String, dynamic> json) {
    return StudentGradeItemModel(
      id: _asInt(json['id']),
      component: GradeComponentModel.fromJson(
        json['grade_component_id'] as Map<String, dynamic>,
      ),
      grade: _asDouble(json['grade']),
    );
  }
}

/// A single student's entry within the response. The API scopes this
/// to the logged-in student, so in practice `students` holds at most
/// one of these.
class StudentGradesEntryModel {
  final int studentCourseId;
  final int studentId;
  final String studentName;
  final List<StudentGradeItemModel> grades;

  const StudentGradesEntryModel({
    required this.studentCourseId,
    required this.studentId,
    required this.studentName,
    required this.grades,
  });

  factory StudentGradesEntryModel.fromJson(Map<String, dynamic> json) {
    return StudentGradesEntryModel(
      studentCourseId: _asInt(json['student_course_id']),
      studentId: _asInt(json['student_id']),
      studentName: json['student_name']?.toString() ?? '',
      grades: (json['grades'] as List? ?? [])
          .map((e) => StudentGradeItemModel.fromJson(e))
          .toList(),
    );
  }
}

/// Raw response of `GET /courses/{course}/{section_type}/student-grades`
/// for one section type.
class GradeSectionBreakdownModel {
  final String sectionType;
  final List<GradeComponentModel> gradeComponents;
  final List<StudentGradesEntryModel> students;

  const GradeSectionBreakdownModel({
    required this.sectionType,
    required this.gradeComponents,
    required this.students,
  });

  factory GradeSectionBreakdownModel.fromJson(
    Map<String, dynamic> json,
    String sectionType,
  ) {
    return GradeSectionBreakdownModel(
      sectionType: sectionType,
      gradeComponents: (json['grade_components'] as List? ?? [])
          .map((e) => GradeComponentModel.fromJson(e))
          .toList(),
      students: (json['students'] as List? ?? [])
          .map((e) => StudentGradesEntryModel.fromJson(e))
          .toList(),
    );
  }

  /// No grading scheme has been published for this section type yet.
  bool get isEmpty => gradeComponents.isEmpty;

  /// The logged-in student's own record, if the backend returned one.
  StudentGradesEntryModel? get myEntry =>
      students.isEmpty ? null : students.first;

  double get earnedTotal {
    final entry = myEntry;
    if (entry == null) return 0;
    return entry.grades.fold(0, (sum, g) => sum + g.grade);
  }

  double get maxTotal =>
      gradeComponents.fold(0, (sum, c) => sum + c.maxGrade);
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
