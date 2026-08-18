import '../models/grade_objection_eligibility_model.dart';
import '../models/grade_objection_model.dart';

abstract class GradeObjectionRemoteDataSource {
  /// [studentGradeId] is the `id` of a single graded component entry
  /// (`StudentGradeItemModel.id` from `.../student-grades`), not a
  /// course id.
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
