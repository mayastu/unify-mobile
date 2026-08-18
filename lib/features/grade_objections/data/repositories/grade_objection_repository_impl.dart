import 'grade_objection_repository.dart';
import '../data_source/grade_objection_remote_datasource.dart';
import '../models/grade_objection_eligibility_model.dart';
import '../models/grade_objection_model.dart';

class GradeObjectionRepositoryImpl implements GradeObjectionRepository {
  final GradeObjectionRemoteDataSource remote;

  GradeObjectionRepositoryImpl(this.remote);

  @override
  Future<GradeObjectionEligibilityModel> getEligibility(int studentGradeId) =>
      remote.getEligibility(studentGradeId);

  @override
  Future<GradeObjectionModel> submitObjection({
    required int studentGradeId,
    required String details,
  }) {
    return remote.submitObjection(
      studentGradeId: studentGradeId,
      details: details,
    );
  }

  @override
  Future<GradeObjectionPageResult> getMyObjections({
    required int page,
    required int perPage,
  }) {
    return remote.getMyObjections(page: page, perPage: perPage);
  }

  @override
  Future<GradeObjectionModel> getObjection(int id) => remote.getObjection(id);
}
