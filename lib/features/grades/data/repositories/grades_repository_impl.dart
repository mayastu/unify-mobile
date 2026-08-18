import 'package:unify/features/grades/data/repositories/grades_repository.dart';

import '../datasource/grades_remote_datasource.dart';
import '../models/current_semester_grades_model.dart';
import '../models/grade_breakdown_model.dart';

class GradesRepositoryImpl implements GradesRepository {
  final GradesRemoteDataSource remote;

  GradesRepositoryImpl(this.remote);

  @override
  Future<CurrentSemesterGradesModel> getCurrentSemesterGrades() {
    return remote.getCurrentSemesterGrades();
  }

  @override
  Future<GradeSectionBreakdownModel> getStudentGrades({
    required int courseId,
    required String sectionType,
  }) {
    return remote.getStudentGrades(
      courseId: courseId,
      sectionType: sectionType,
    );
  }
}
