import 'classroom_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/classroom_model.dart';

class ClassroomRemoteDataSourceImpl implements ClassroomRemoteDataSource {
  final ApiConsumer api;

  ClassroomRemoteDataSourceImpl(this.api);

  @override
  Future<List<ClassroomModel>> getClassrooms() async {
    final response = await api.get(
      EndPoints.classrooms,
    );

    final List data = response["data"];

    return data
        .map((e) => ClassroomModel.fromJson(e))
        .toList();
  }
}
