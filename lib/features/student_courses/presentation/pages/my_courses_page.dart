import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../data/models/student_course_model.dart';
import '../cubit/student_course_cubit.dart';
import '../cubit/student_course_state.dart';
import '../widgets/student_course_card.dart';

class MyCoursesPage extends StatelessWidget {
  const MyCoursesPage({super.key});

  void _confirmWithdraw(BuildContext context, StudentCourseModel course) {
    final cubit = context.read<StudentCourseCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Withdraw from course'),
        content: Text(
          'Withdraw from ${course.course.courseCode} · ${course.course.name}? '
          'You will be able to register for it again while registration is open.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.withdraw(course.id);
            },
            child: const Text(
              'Withdraw',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentCourseCubit, StudentCourseState>(
      listener: (context, state) {
        if (state is StudentCourseWithdrawSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Withdrawn. The course is open for registration again.',
              ),
              backgroundColor: AppColors.textSecondary,
            ),
          );
        }

        if (state is StudentCourseWithdrawFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
          title: const Text('My courses'),
        ),
        body: BlocBuilder<StudentCourseCubit, StudentCourseState>(
          builder: (context, state) {
            if (state is StudentCourseLoading ||
                state is StudentCourseInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StudentCourseLoadFailure) {
              return AppEmpty(
                icon: Icons.wifi_off_rounded,
                message: state.message,
                actionText: 'Retry',
                onAction: () =>
                    context.read<StudentCourseCubit>().getStudentCourses(),
              );
            }

            final courses = state.courses;

            if (courses.isEmpty) {
              return const AppEmpty(
                icon: Icons.fact_check_outlined,
                message: "You haven't registered for any courses yet.",
              );
            }

            final withdrawingId =
                state is StudentCourseWithdrawing ? state.withdrawingId : null;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<StudentCourseCubit>().getStudentCourses(),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final studentCourse = courses[index];

                  return StudentCourseCard(
                    studentCourse: studentCourse,
                    isWithdrawing: studentCourse.id == withdrawingId,
                    onWithdraw: () => _confirmWithdraw(context, studentCourse),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
