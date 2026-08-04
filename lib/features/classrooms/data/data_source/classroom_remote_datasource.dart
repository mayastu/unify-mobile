import '../models/classroom_model.dart';

abstract class ClassroomRemoteDataSource {
  Future<List<ClassroomModel>> getClassrooms();
}
