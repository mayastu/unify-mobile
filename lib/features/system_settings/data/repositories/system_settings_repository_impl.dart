import '../data_source/system_settings_remote_datasource.dart';
import '../models/system_settings_model.dart';
import 'system_settings_repository.dart';

class SystemSettingsRepositoryImpl implements SystemSettingsRepository {
  final SystemSettingsRemoteDataSource remoteDataSource;

  SystemSettingsRepositoryImpl(this.remoteDataSource);

  @override
  Future<SystemSettingsModel> getSettings() {
    return remoteDataSource.getSettings();
  }
}
