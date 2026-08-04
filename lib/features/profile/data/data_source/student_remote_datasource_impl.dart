import 'package:unify/features/profile/data/data_source/student_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/student_model.dart';

class StudentRemoteDataSourceImpl
    implements StudentRemoteDataSource {

  final ApiConsumer api;

  StudentRemoteDataSourceImpl(this.api);

  @override
  Future<StudentModel> getProfile() async {

    final response = await api.get(
      EndPoints.getProfile,
    );

    return StudentModel.fromJson(response["data"]);
  }
}