import '../models/student_model.dart';

abstract class StudentRepository {
  Future<StudentModel> getProfile();
}