import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/grade_breakdown_cubit.dart';
import '../cubit/grade_breakdown_state.dart';
import '../widgets/grade_section_card.dart';

class GradeBreakdownPage extends StatelessWidget {
  const GradeBreakdownPage({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
  });

  final int courseId;
  final String courseName;
  final String courseCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(courseCode.isEmpty ? courseName : '$courseCode • $courseName'),
        actions: [
          IconButton(
            onPressed: () => context.push('/grade-objections'),
            tooltip: 'My objections',
            icon: const Icon(Icons.gavel_rounded),
          ),
        ],
      ),
      body: BlocBuilder<GradeBreakdownCubit, GradeBreakdownState>(
        builder: (context, state) {
          if (state is GradeBreakdownLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GradeBreakdownFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<GradeBreakdownCubit>().loadBreakdown(courseId),
            );
          }

          if (state is GradeBreakdownEmpty) {
            return const AppEmpty(
              icon: Icons.grade_outlined,
              message: 'No grade breakdown has been published for this '
                  'course yet.',
            );
          }

          final sections = (state as GradeBreakdownSuccess).sections;

          if (sections.length == 1) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<GradeBreakdownCubit>().loadBreakdown(courseId),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [GradeSectionCard(section: sections.first)],
              ),
            );
          }

          // More than one section type (e.g. theory + practical) —
          // let the student switch between them with tabs.
          return DefaultTabController(
            length: sections.length,
            child: Column(
              children: [
                Container(
                  color: AppColors.background,
                  child: TabBar(
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    tabs: sections
                        .map((s) => Tab(text: _label(s.sectionType)))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: sections.map((section) {
                      return RefreshIndicator(
                        onRefresh: () => context
                            .read<GradeBreakdownCubit>()
                            .loadBreakdown(courseId),
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: [GradeSectionCard(section: section)],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _label(String sectionType) {
    switch (sectionType) {
      case 'theory':
        return 'Theory';
      case 'practical':
        return 'Practical';
      case 'project':
        return 'Project';
      default:
        return sectionType;
    }
  }
}
