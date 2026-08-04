class InstructorUserModel {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  const InstructorUserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory InstructorUserModel.fromJson(Map<String, dynamic> json) {
    return InstructorUserModel(
      id: json['id'],
      username: json['username'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class InstructorDepartmentModel {
  final int id;
  final String name;

  const InstructorDepartmentModel({
    required this.id,
    required this.name,
  });

  factory InstructorDepartmentModel.fromJson(Map<String, dynamic> json) {
    return InstructorDepartmentModel(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class InstructorModel {
  final int id;
  final InstructorUserModel user;
  final String staffType;
  final List<InstructorDepartmentModel> departments;

  const InstructorModel({
    required this.id,
    required this.user,
    required this.staffType,
    required this.departments,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'],
      user: InstructorUserModel.fromJson(json['user']),
      staffType: json['staff_type'] ?? '',
      departments: (json['departments'] as List? ?? [])
          .map((e) => InstructorDepartmentModel.fromJson(e))
          .toList(),
    );
  }

  String get fullName => '${user.firstName} ${user.lastName}'.trim();
}
