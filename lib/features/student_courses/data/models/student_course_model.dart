import '../../../course_sections/data/models/course_section_model.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../semesters/data/models/semester_model.dart';

/// A single enrollment record: one course the student is/was
/// registered in for a given semester.
class StudentCourseModel {
  final int id;
  final CourseModel course;
  final SemesterModel semester;
  final int attemptNo;
  final String? finalGrade;
  final String status;

  /// The section(s) this enrollment is in for [course] — usually one,
  /// but a `theory_practical` course can enroll the student in a
  /// theory section and a practical section at once.
  final List<CourseSectionModel> sections;
  final String createdAt;

  const StudentCourseModel({
    required this.id,
    required this.course,
    required this.semester,
    required this.attemptNo,
    required this.finalGrade,
    required this.status,
    required this.sections,
    required this.createdAt,
  });

  factory StudentCourseModel.fromJson(Map<String, dynamic> json) {
    // The schema documents `course` and `semester` as arrays holding
    // exactly one item rather than bare objects — unwrap that here so
    // the rest of the app can work with plain CourseModel/SemesterModel.
    final courseJson =
        (json['course'] as List).first as Map<String, dynamic>;
    final semesterJson =
        (json['semester'] as List).first as Map<String, dynamic>;

    return StudentCourseModel(
      id: _asInt(json['id']),
      course: CourseModel.fromJson(courseJson),
      semester: SemesterModel.fromJson(semesterJson),
      attemptNo: _asInt(json['attempt_no']),
      finalGrade: json['final_grade']?.toString(),
      status: json['status'],
      sections: _parseSections(json['course_sections']),
      createdAt: json['created_at'],
    );
  }

  /// `course_sections` comes back double-nested — a list of one-item
  /// lists, e.g. `[[{...}]]` — rather than a flat list of sections.
  /// Flatten it here so the rest of the app just sees
  /// `List<CourseSectionModel>`.
  static List<CourseSectionModel> _parseSections(dynamic raw) {
    if (raw is! List) return const [];

    final sections = <CourseSectionModel>[];
    for (final entry in raw) {
      if (entry is Map<String, dynamic>) {
        sections.add(CourseSectionModel.fromJson(entry));
      } else if (entry is List) {
        for (final inner in entry) {
          if (inner is Map<String, dynamic>) {
            sections.add(CourseSectionModel.fromJson(inner));
          }
        }
      }
    }
    return sections;
  }

  /// The docs describe `id`/`attempt_no` as strings, but the live
  /// server returns numbers (same quirk as CourseModel). Accept either.
  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Only an active enrollment can be withdrawn from.
  bool get canWithdraw => status == 'enrolled';

  String get displayStatus {
    switch (status) {
      case 'enrolled':
        return 'Enrolled';
      case 'withdrawn':
        return 'Withdrawn';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      default:
        return status;
    }
  }
}
