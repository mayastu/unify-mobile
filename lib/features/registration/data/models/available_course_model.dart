import '../../../course_sections/data/models/course_section_model.dart';
import '../../../courses/data/models/course_model.dart';

class AvailableCourseModel {
  final CourseModel course;
  final List<CourseSectionModel> theorySections;
  final List<CourseSectionModel> practicalSections;
  final List<CourseSectionModel> projectSections;

  const AvailableCourseModel({
    required this.course,
    required this.theorySections,
    required this.practicalSections,
    required this.projectSections,
  });

  factory AvailableCourseModel.fromJson(Map<String, dynamic> json) {
    final sections = json['sections'] as Map<String, dynamic>? ?? {};

    List<CourseSectionModel> parseGroup(String key) {
      return (sections[key] as List? ?? [])
          .map((e) => CourseSectionModel.fromJson(e))
          .toList();
    }

    return AvailableCourseModel(
      course: CourseModel.fromJson(json['course']),
      theorySections: parseGroup('theory'),
      practicalSections: parseGroup('practical'),
      projectSections: parseGroup('project'),
    );
  }

  bool get hasAnySection =>
      theorySections.isNotEmpty ||
      practicalSections.isNotEmpty ||
      projectSections.isNotEmpty;
}
