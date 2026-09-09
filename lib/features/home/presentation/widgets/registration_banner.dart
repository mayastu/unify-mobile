import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../registration/presentation/cubit/registration_cubit.dart';
import '../../../registration/presentation/cubit/registration_state.dart';

/// Home's version of the mockup's "Registration is open" banner.
///
/// "Open" here is driven entirely by RegistrationCubit's real state —
/// it shows only once available courses have loaded and the list is
/// non-empty (i.e. registration is actually open), and renders
/// nothing otherwise (loading, failure, or no available courses).
class RegistrationBanner extends StatelessWidget {
  const RegistrationBanner({super.key, this.palette = AppPalette.light});

  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationCubit, RegistrationState>(
      builder: (context, state) {
        final isOpen = state is RegistrationLoaded &&
            state.availableCourses.isNotEmpty;

        if (!isOpen) return const SizedBox.shrink();

        final count = state.availableCourses.length;

        return GestureDetector(
          onTap: () => context.push('/registration'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: palette.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: palette.border),
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
                  child: Icon(Icons.campaign_rounded,
                      color: palette.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registration is open',
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
                        '$count course${count == 1 ? '' : 's'} available — register now',
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
