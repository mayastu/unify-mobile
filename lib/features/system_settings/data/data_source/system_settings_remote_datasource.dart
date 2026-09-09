import '../models/system_settings_model.dart';

abstract class SystemSettingsRemoteDataSource {
  /// GET /api/systemsettings/{id}. The API only exposes a "show by
  /// id" endpoint (no index/list), and every response we've seen has
  /// `id: 1` — there's just one settings record system-wide, so this
  /// always fetches id 1.
  Future<SystemSettingsModel> getSettings();
}
