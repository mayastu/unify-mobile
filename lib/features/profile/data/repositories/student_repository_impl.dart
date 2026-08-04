import '../data_source/student_remote_datasource.dart';
import '../models/student_model.dart';
import 'student_repository.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentRemoteDataSource remoteDataSource;

  StudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudentModel> getProfile() {
    return remoteDataSource.getProfile();
  }
}