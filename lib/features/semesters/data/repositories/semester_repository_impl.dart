import 'package:unify/features/semesters/data/repositories/semester_repository.dart';
import '../datasource/semester_remote_datasource.dart';
import '../models/semester_model.dart';

class SemesterRepositoryImpl
    implements SemesterRepository {

  final SemesterRemoteDataSource remote;

  SemesterRepositoryImpl(this.remote);

  @override
  Future<List<SemesterModel>> getSemesters() {
    return remote.getSemesters();
  }
}