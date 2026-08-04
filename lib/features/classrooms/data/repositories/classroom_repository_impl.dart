import 'classroom_repository.dart';
import '../data_source/classroom_remote_datasource.dart';
import '../models/classroom_model.dart';

class ClassroomRepositoryImpl implements ClassroomRepository {
  final ClassroomRemoteDataSource remote;

  ClassroomRepositoryImpl(this.remote);

  @override
  Future<List<ClassroomModel>> getClassrooms() {
    return remote.getClassrooms();
  }
}
