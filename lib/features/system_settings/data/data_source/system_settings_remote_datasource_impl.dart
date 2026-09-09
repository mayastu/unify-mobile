import 'system_settings_remote_datasource.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/system_settings_model.dart';

class SystemSettingsRemoteDataSourceImpl implements SystemSettingsRemoteDataSource {
  final ApiConsumer api;

  SystemSettingsRemoteDataSourceImpl(this.api);

  @override
  Future<SystemSettingsModel> getSettings() async {
    final response = await api.get('${EndPoints.systemSettings}/1');
    return SystemSettingsModel.fromJson(response['data']);
  }
}
