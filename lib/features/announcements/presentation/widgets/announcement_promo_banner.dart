import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../cubit/announcement_cubit.dart';
import '../cubit/announcement_state.dart';

/// Home's version of the mockup's "Registration is open for Fall
/// 2026" banner — pulls the most recent real announcement instead of
/// a hardcoded message, since that promo text isn't backed by any
/// field the API actually returns. Renders nothing while loading or
/// if there are no announcements, so it never shows a placeholder.
class AnnouncementPromoBanner extends StatelessWidget {
  const AnnouncementPromoBanner({super.key, required this.palette});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementCubit, AnnouncementState>(
      builder: (context, state) {
        if (state.items.isEmpty) return const SizedBox.shrink();

        final latest = state.items.first;

        return GestureDetector(
          onTap: () => context.push('/notifications', extra: 1),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.waveGold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: palette.secondary.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.campaign_rounded, color: palette.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        latest.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        latest.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: palette.textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: palette.textSecondary),
              ],
            ),
          ),
        );
      },
    );
  }
}
