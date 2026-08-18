import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/grades_cubit.dart';
import '../cubit/grades_state.dart';
import '../widgets/grade_course_card.dart';
import '../widgets/grade_summary_card.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Grades'),
      ),
      body: BlocBuilder<GradesCubit, GradesState>(
        builder: (context, state) {
          if (state is GradesLoading || state is GradesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GradesFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<GradesCubit>().getCurrentSemesterGrades(),
            );
          }

          final grades = (state as GradesSuccess).grades;

          if (grades.courses.isEmpty) {
            return const AppEmpty(
              icon: Icons.grade_outlined,
              message: 'No grades yet for this semester.',
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<GradesCubit>().getCurrentSemesterGrades(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: grades.courses.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GradeSummaryCard(grades: grades);
                }

                final course = grades.courses[index - 1];
                final courseId = int.tryParse(course.courseId);

                return GradeCourseCard(
                  course: course,
                  // Falls back to a non-tappable card if the id
                  // doesn't parse, instead of crashing on navigation.
                  onTap: courseId == null
                      ? null
                      : () => context.push(
                            '/grades/$courseId',
                            extra: course,
                          ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
