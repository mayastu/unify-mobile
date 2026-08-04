import '../models/semester_model.dart';

abstract class SemesterRepository {
  Future<List<SemesterModel>> getSemesters();
}