import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_empty.dart';
import '../cubit/announcement_cubit.dart';
import '../cubit/announcement_state.dart';
import 'announcement_card.dart';

class AnnouncementsTab extends StatefulWidget {
  const AnnouncementsTab({super.key});

  @override
  State<AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<AnnouncementsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AnnouncementCubit>().getAnnouncements();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AnnouncementCubit>().loadMore();
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
    return BlocBuilder<AnnouncementCubit, AnnouncementState>(
      builder: (context, state) {
        if (state is AnnouncementLoading || state is AnnouncementInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AnnouncementFailure && state.items.isEmpty) {
          return AppEmpty(
            icon: Icons.wifi_off_rounded,
            message: state.message,
            actionText: 'Retry',
            onAction: () => context.read<AnnouncementCubit>().getAnnouncements(),
          );
        }

        if (state.items.isEmpty) {
          return const AppEmpty(
            icon: Icons.campaign_outlined,
            message: 'No announcements yet.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<AnnouncementCubit>().getAnnouncements(),
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

              final announcement = state.items[index];

              return AnnouncementCard(
                announcement: announcement,
                // The list response already carries the full title/body,
                // so the item is forwarded via `extra` instead of the
                // details page re-fetching it — same pattern as
                // CourseDetailsPage.
                onTap: () =>
                    context.push('/announcements/${announcement.id}', extra: announcement),
              );
            },
          ),
        );
      },
    );
  }
}
