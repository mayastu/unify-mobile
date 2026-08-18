import '../data_source/announcement_remote_datasource.dart';
import '../models/announcement_model.dart';
import '../models/announcement_page_result.dart';
import 'announcement_repository.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource remoteDataSource;

  AnnouncementRepositoryImpl(this.remoteDataSource);

  @override
  Future<AnnouncementPageResult> getAnnouncements({
    required int page,
    required int perPage,
  }) {
    return remoteDataSource.getAnnouncements(page: page, perPage: perPage);
  }

  @override
  Future<AnnouncementModel> getAnnouncement(String id) {
    return remoteDataSource.getAnnouncement(id);
  }
}
