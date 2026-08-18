import '../models/current_semester_grades_model.dart';
import '../models/grade_breakdown_model.dart';

abstract class GradesRepository {
  Future<CurrentSemesterGradesModel> getCurrentSemesterGrades();

  Future<GradeSectionBreakdownModel> getStudentGrades({
    required int courseId,
    required String sectionType,
  });
}
