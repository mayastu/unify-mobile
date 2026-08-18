import '../models/announcement_model.dart';
import '../models/announcement_page_result.dart';

abstract class AnnouncementRemoteDataSource {
  /// GET /api/announcements — the backend already scopes this to
  /// whatever audience the logged-in student belongs to, so no
  /// audience filter is passed from the client.
  Future<AnnouncementPageResult> getAnnouncements({
    required int page,
    required int perPage,
  });

  /// GET /api/announcements/{id} — not used by the list page (the
  /// list response already carries the full body), but available for
  /// a details page opened from a push notification that only has the
  /// announcement id in its payload.
  Future<AnnouncementModel> getAnnouncement(String id);
}
