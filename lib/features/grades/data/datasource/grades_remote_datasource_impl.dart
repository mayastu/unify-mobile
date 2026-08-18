import 'package:unify/features/grades/data/datasource/grades_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/current_semester_grades_model.dart';
import '../models/grade_breakdown_model.dart';

class GradesRemoteDataSourceImpl implements GradesRemoteDataSource {
  final ApiConsumer api;

  GradesRemoteDataSourceImpl(this.api);

  @override
  Future<CurrentSemesterGradesModel> getCurrentSemesterGrades() async {
    final response = await api.get(
      EndPoints.currentSemesterGrades,
    );

    final Map<String, dynamic> data = response["data"];

    return CurrentSemesterGradesModel.fromJson(data);
  }

  @override
  Future<GradeSectionBreakdownModel> getStudentGrades({
    required int courseId,
    required String sectionType,
  }) async {
    final response = await api.get(
      EndPoints.studentGrades(courseId, sectionType),
    );

    final Map<String, dynamic> data = response["data"];

    return GradeSectionBreakdownModel.fromJson(data, sectionType);
  }
}
