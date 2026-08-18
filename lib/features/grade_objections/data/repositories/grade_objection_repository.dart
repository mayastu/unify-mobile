import '../models/grade_objection_eligibility_model.dart';
import '../models/grade_objection_model.dart';

abstract class GradeObjectionRepository {
  Future<GradeObjectionEligibilityModel> getEligibility(int studentGradeId);

  Future<GradeObjectionModel> submitObjection({
    required int studentGradeId,
    required String details,
  });

  Future<GradeObjectionPageResult> getMyObjections({
    required int page,
    required int perPage,
  });

  Future<GradeObjectionModel> getObjection(int id);
}
