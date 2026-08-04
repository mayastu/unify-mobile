import '../models/classroom_model.dart';

abstract class ClassroomRepository {
  Future<List<ClassroomModel>> getClassrooms();
}
