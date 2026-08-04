import '../models/student_model.dart';

abstract class StudentRemoteDataSource {
  Future<StudentModel> getProfile();
}