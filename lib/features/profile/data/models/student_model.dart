import '../../../auth/data/models/user_model.dart';
import 'department_model.dart';

class StudentModel {
  final int id;
  final UserModel user;
  final DepartmentModel department;
  final String studentNumber;
  final String? nfcUid;

  const StudentModel({
    required this.id,
    required this.user,
    required this.department,
    required this.studentNumber,
    required this.nfcUid,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      department: DepartmentModel.fromJson(json['department']),
      studentNumber: json['student_number']?.toString() ?? '',
      // Most students never register an NFC card, so this is null
      // for them — it was previously typed as a required String and
      // crashed with "type 'Null' is not a subtype of type 'String'"
      // the moment one of these records had no card on file.
      nfcUid: json['nfc_uid'],
    );
  }
}