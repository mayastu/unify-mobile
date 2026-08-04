import '../../../courses/data/models/course_model.dart';
import 'instructor_model.dart';

class CourseSectionModel {
  final int id;
  final CourseModel course;
  final InstructorModel? instructor;
  final String sectionName;
  final int capacity;
  final String sectionType;
  final String createdAt;

  const CourseSectionModel({
    required this.id,
    required this.course,
    required this.instructor,
    required this.sectionName,
    required this.capacity,
    required this.sectionType,
    required this.createdAt,
  });

  factory CourseSectionModel.fromJson(Map<String, dynamic> json) {
    return CourseSectionModel(
      id: json['id'],
      course: CourseModel.fromJson(json['course']),
      // Some sections may not have an instructor assigned yet.
      instructor: json['instructor'] == null
          ? null
          : InstructorModel.fromJson(json['instructor']),
      sectionName: json['section_name'] ?? '',
      capacity: _asInt(json['capacity']),
      sectionType: json['section_type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  /// The docs describe `capacity` as a string in the schema, but the
  /// live server returns a number. Accept either.
  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
}
