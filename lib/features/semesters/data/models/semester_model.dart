class SemesterModel {
  final int id;
  final String name;
  final String academicYear;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final String createdAt;

  const SemesterModel({
    required this.id,
    required this.name,
    required this.academicYear,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.createdAt,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'],
      name: json['name'],
      academicYear: json['academic_year'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isCurrent: json['is_current'] == 1,
      createdAt: json['created_at'],
    );
  }
}