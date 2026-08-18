import 'notification_model.dart';

/// One page of the `/notifications` list, plus enough pagination info
/// for the cubit to know whether "load more" should keep fetching.
class NotificationPageResult {
  final List<NotificationModel> items;
  final int currentPage;
  final int lastPage;

  const NotificationPageResult({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });
}