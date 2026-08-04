class DepartmentModel {
  final int id;
  final String name;
  final String code;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}