import 'announcement_model.dart';

/// One page of `GET /api/announcements`, plus enough pagination info
/// for the cubit to know whether "load more" should keep fetching.
/// Mirrors NotificationPageResult from the notifications feature.
class AnnouncementPageResult {
  final List<AnnouncementModel> items;
  final int currentPage;
  final int lastPage;

  const AnnouncementPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });
}
