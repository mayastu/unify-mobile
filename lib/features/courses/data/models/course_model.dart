import 'course_department_model.dart';

class CourseModel {
  final int id;
  final String courseCode;
  final String name;
  final int creditHours;
  final int contactHours;
  final int maxAbsences;
  final String courseType;
  final List<CourseModel> prerequisites;
  final List<CourseDepartmentModel> departments;
  final String createdAt;
  final String updatedAt;

  const CourseModel({
    required this.id,
    required this.courseCode,
    required this.name,
    required this.creditHours,
    required this.contactHours,
    required this.maxAbsences,
    required this.courseType,
    required this.prerequisites,
    required this.departments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      courseCode: json['course_code'],
      name: json['name'],
      creditHours: _asInt(json['credit_hours']),
      contactHours: _asInt(json['contact_hours']),
      maxAbsences: _asInt(json['max_absences']),
      courseType: json['course_type'],
      prerequisites: (json['prerequisites'] as List? ?? [])
          .map((e) => CourseModel.fromJson(e))
          .toList(),
      departments: (json['departments'] as List? ?? [])
          .map((e) => CourseDepartmentModel.fromJson(e))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// The API docs describe credit/contact/absence figures as strings in
  /// the schema, but the live server returns numbers. Accept either.
  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  String get displayCourseType {
    switch (courseType) {
      case 'theory':
        return 'Theory';
      case 'theory_practical':
        return 'Theory & practical';
      case 'project':
        return 'Project';
      default:
        return courseType;
    }
  }
}
