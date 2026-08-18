import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  static const _perPage = 20;
  int _page = 1;

  NotificationCubit(this.repository) : super(const NotificationInitial());

  Future<void> getNotifications({bool refresh = true}) async {
    if (refresh) {
      _page = 1;
      emit(NotificationLoading(unreadCount: state.unreadCount));
    }

    try {
      final result = await repository.getNotifications(
        page: _page,
        perPage: _perPage,
      );

      emit(NotificationLoaded(
        items: refresh ? result.items : [...state.items, ...result.items],
        unreadCount: state.unreadCount,
        hasMore: _page < result.lastPage,
      ));

      // Keep the badge in sync every time the list loads too.
      getUnreadCount();
    } catch (e) {
      emit(NotificationFailure(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> loadMore() async {
    if (state is! NotificationLoaded) return;

    final current = state as NotificationLoaded;
    if (!current.hasMore) return;

    emit(NotificationLoadingMore(
      items: current.items,
      unreadCount: current.unreadCount,
      hasMore: current.hasMore,
    ));

    _page++;

    try {
      final result = await repository.getNotifications(
        page: _page,
        perPage: _perPage,
      );

      emit(NotificationLoaded(
        items: [...current.items, ...result.items],
        unreadCount: current.unreadCount,
        hasMore: _page < result.lastPage,
      ));
    } catch (_) {
      _page--;

      // Keep the list the user already sees intact; they can just
      // scroll again to retry "load more".
      emit(NotificationLoaded(
        items: current.items,
        unreadCount: current.unreadCount,
        hasMore: current.hasMore,
      ));
    }
  }

  Future<void> getUnreadCount() async {
    try {
      final count = await repository.getUnreadCount();
      emit(_withUnreadCount(count));
    } catch (_) {
      // Silent on purpose — the badge just keeps showing its last
      // known value instead of surfacing an error for a background sync.
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      final updated = await repository.markAsRead(id);

      final items = state.items
          .map((n) => n.id == id ? updated : n)
          .toList();

      emit(NotificationLoaded(
        items: items,
        unreadCount: _decrement(state.unreadCount),
        hasMore: state.hasMore,
      ));
    } catch (_) {
      // Non-critical — the tap still navigates even if this silently
      // fails, it just won't visually mark the item read.
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();

      final items = state.items.map((n) => n.copyWith(isRead: true)).toList();

      emit(NotificationLoaded(items: items, unreadCount: 0, hasMore: state.hasMore));
    } catch (e) {
      emit(NotificationFailure(e.toString(), unreadCount: state.unreadCount));
    }
  }

  Future<void> deleteNotification(String id) async {
    NotificationModel? target;
    for (final n in state.items) {
      if (n.id == id) {
        target = n;
        break;
      }
    }

    try {
      await repository.deleteNotification(id);

      final items = state.items.where((n) => n.id != id).toList();
      final unreadCount = (target != null && !target.isRead)
          ? _decrement(state.unreadCount)
          : state.unreadCount;

      emit(NotificationLoaded(items: items, unreadCount: unreadCount, hasMore: state.hasMore));
    } catch (e) {
      emit(NotificationFailure(e.toString(), unreadCount: state.unreadCount));
    }
  }

  NotificationLoaded _withUnreadCount(int count) {
    return NotificationLoaded(
      items: state.items,
      unreadCount: count,
      hasMore: state.hasMore,
    );
  }

  int _decrement(int count) => count > 0 ? count - 1 : 0;
}