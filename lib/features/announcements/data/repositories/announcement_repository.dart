import '../models/announcement_model.dart';
import '../models/announcement_page_result.dart';

abstract class AnnouncementRepository {
  Future<AnnouncementPageResult> getAnnouncements({
    required int page,
    required int perPage,
  });

  Future<AnnouncementModel> getAnnouncement(String id);
}
