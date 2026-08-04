import '../models/semester_model.dart';

abstract class SemesterRemoteDataSource {
  Future<List<SemesterModel>> getSemesters();
}