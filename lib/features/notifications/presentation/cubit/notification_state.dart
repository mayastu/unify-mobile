import '../../data/models/notification_model.dart';

/// Every state carries [unreadCount] so the badge (e.g. on the Home
/// bell icon) always has a value to show, regardless of whether the
/// notifications list itself is loading, loaded, or failed.
abstract class NotificationState {
  const NotificationState({
    this.items = const [],
    this.unreadCount = 0,
    this.hasMore = true,
  });

  final List<NotificationModel> items;
  final int unreadCount;
  final bool hasMore;
}

class NotificationInitial extends NotificationState {
  const NotificationInitial({super.unreadCount});
}

class NotificationLoading extends NotificationState {
  const NotificationLoading({super.unreadCount});
}

class NotificationLoadingMore extends NotificationState {
  const NotificationLoadingMore({
    required super.items,
    required super.unreadCount,
    required super.hasMore,
  });
}

class NotificationLoaded extends NotificationState {
  const NotificationLoaded({
    required super.items,
    required super.unreadCount,
    required super.hasMore,
  });
}

class NotificationFailure extends NotificationState {
  const NotificationFailure(this.message, {super.unreadCount});

  final String message;
}