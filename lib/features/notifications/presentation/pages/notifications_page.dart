import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../cubit/notification_cubit.dart';
import '../widgets/notifications_tab.dart';
import '../../../announcements/presentation/widgets/announcements_tab.dart';

/// One screen, two sections, reached from the single bell icon in
/// [HomeHeader] — "Notifications" (personal: grades, registration,
/// etc.) and "Announcements" (broadcast messages from instructors /
/// admin). They're kept as tabs here rather than as two separate
/// screens/buttons since they're the same kind of content (a feed the
/// student reads) just from two different sources.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, this.initialTab = 0});

  /// 0 = Notifications, 1 = Announcements. Lets a push notification
  /// with `screen: "announcements"` open straight into that tab
  /// instead of always landing on Notifications first.
  final int initialTab;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Notifications'),
        actions: [
          // Only meaningful for the Notifications tab — Announcements
          // don't have a read/unread concept on the student side.
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              if (_tabController.index != 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context.read<NotificationCubit>().markAllAsRead(),
                child: const Text('Mark all read'),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Notifications'),
            Tab(text: 'Announcements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NotificationsTab(),
          AnnouncementsTab(),
        ],
      ),
    );
  }
}
