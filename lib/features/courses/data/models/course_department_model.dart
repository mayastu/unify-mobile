class CourseDepartmentModel {
  final int id;
  final String name;
  final String studyYear;
  final String studySemester;

  const CourseDepartmentModel({
    required this.id,
    required this.name,
    required this.studyYear,
    required this.studySemester,
  });

  factory CourseDepartmentModel.fromJson(Map<String, dynamic> json) {
    return CourseDepartmentModel(
      id: json['id'],
      name: json['name'],
      studyYear: json['study_year'] ?? '',
      studySemester: json['study_semester'] ?? '',
    );
  }
}
