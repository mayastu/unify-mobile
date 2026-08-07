import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../../courses/data/models/course_model.dart';
import '../cubit/course_section_cubit.dart';
import '../cubit/course_section_state.dart';
import '../widgets/course_section_card.dart';

class CourseSectionsPage extends StatelessWidget {
  const CourseSectionsPage({super.key, this.course});

  /// When provided, the list is filtered to sections of this course
  /// only (opened from CourseDetailsPage). When null, every offered
  /// section is shown.
  final CourseModel? course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        title: Text(course == null ? 'Course sections' : course!.courseCode),
      ),
      body: BlocBuilder<CourseSectionCubit, CourseSectionState>(
        builder: (context, state) {
          if (state is CourseSectionLoading ||
              state is CourseSectionInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseSectionFailure) {
            return AppEmpty(
              icon: Icons.wifi_off_rounded,
              message: state.message,
              actionText: 'Retry',
              onAction: () =>
                  context.read<CourseSectionCubit>().getCourseSections(),
            );
          }

          final allSections = (state as CourseSectionSuccess).sections;

          final sections = course == null
              ? allSections
              : allSections
                  .where((section) => section.course?.id == course!.id)
                  .toList();

          if (sections.isEmpty) {
            return const AppEmpty(
              icon: Icons.event_busy_rounded,
              message: 'No sections offered yet.',
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<CourseSectionCubit>().getCourseSections(),
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: sections.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return CourseSectionCard(
                  section: sections[index],
                  showCourseName: course == null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
