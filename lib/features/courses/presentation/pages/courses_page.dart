import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../cubit/course_cubit.dart';
import '../cubit/course_state.dart';
import '../widgets/course_card.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Courses'),
      ),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading || state is CourseInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () => context.read<CourseCubit>().getCourses(),
            );
          }

          final courses = (state as CourseSuccess).courses;

          if (courses.isEmpty) {
            return const AppEmpty(
              icon: Icons.school_outlined,
              message: 'No courses available yet.',
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CourseCubit>().getCourses(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final course = courses[index];

                return CourseCard(
                  course: course,
                  // The list response already carries full course data,
                  // so it's forwarded as `extra` instead of re-fetching
                  // it by id on the details page.
                  onTap: () => context.push(
                    '/courses/${course.id}',
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
