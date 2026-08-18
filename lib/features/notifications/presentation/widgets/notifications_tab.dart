import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_empty.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import 'notification_card.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().getNotifications();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state is NotificationLoading || state is NotificationInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationFailure && state.items.isEmpty) {
          return AppEmpty(
            icon: Icons.wifi_off_rounded,
            message: state.message,
            actionText: 'Retry',
            onAction: () => context.read<NotificationCubit>().getNotifications(),
          );
        }

        if (state.items.isEmpty) {
          return const AppEmpty(
            icon: Icons.notifications_none_rounded,
            message: 'No notifications yet.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<NotificationCubit>().getNotifications(),
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: state.items.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final notification = state.items[index];

              return NotificationCard(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    context.read<NotificationCubit>().markAsRead(notification.id);
                  }
                  // Deep-link handling (based on `notification.screen`)
                  // lives in NotificationService for pushes — tapping
                  // an item here just marks it read for now. Add
                  // navigation here too once `screen` values are final.
                },
                onDismissed: () =>
                    context.read<NotificationCubit>().deleteNotification(notification.id),
              );
            },
          ),
        );
      },
    );
  }
}
