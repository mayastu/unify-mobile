import 'package:unify/features/semesters/data/datasource/semester_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/semester_model.dart';

class SemesterRemoteDataSourceImpl
    implements SemesterRemoteDataSource {

  final ApiConsumer api;

  SemesterRemoteDataSourceImpl(this.api);

  @override
  Future<List<SemesterModel>> getSemesters() async {

    final response = await api.get(
      EndPoints.semesters,
    );

    final List data = response["data"];

    return data
        .map((e) => SemesterModel.fromJson(e))
        .toList();
  }
}