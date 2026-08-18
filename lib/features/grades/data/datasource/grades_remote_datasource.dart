import '../models/current_semester_grades_model.dart';
import '../models/grade_breakdown_model.dart';

abstract class GradesRemoteDataSource {
  Future<CurrentSemesterGradesModel> getCurrentSemesterGrades();

  /// Grade-component breakdown for one course + section type
  /// (theory / practical / project). Returns an "empty" result
  /// (no components, no students) if no grading scheme has been
  /// published yet for that combination — this is not an error.
  Future<GradeSectionBreakdownModel> getStudentGrades({
    required int courseId,
    required String sectionType,
  });
}
