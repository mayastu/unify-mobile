import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty.dart';
import '../../data/models/course_registration_request.dart';
import '../cubit/registration_cubit.dart';
import '../cubit/registration_state.dart';
import '../widgets/course_selection_card.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // courseId -> (sectionType -> sectionId)
  final Map<int, SectionSelection> _selections = {};

  void _onSectionSelected(int courseId, String type, int? sectionId) {
    print("Selected:");
    print("courseId = $courseId");
    print("type = $type");
    print("sectionId = $sectionId");

    setState(() {
      final courseSelection = _selections.putIfAbsent(courseId, () => {});
      courseSelection[type] = sectionId;
    });

    print(_selections);
  }

  List<CourseRegistrationRequest> _buildRequests() {
    final requests = <CourseRegistrationRequest>[];

    _selections.forEach((courseId, typeSelection) {
      final sectionIds = typeSelection.values.whereType<int>().toList();

      if (sectionIds.isNotEmpty) {
        requests.add(
          CourseRegistrationRequest(
            courseId: courseId,
            sectionIds: sectionIds,
          ),
        );
      }
    });

    return requests;
  }

  void _submit(BuildContext context) {
    final requests = _buildRequests();

    if (requests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pick at least one section before registering.'),
        ),
      );
      return;
    }

    context.read<RegistrationCubit>().submitRegistration(requests);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCourseCount = _selections.values
        .where((s) => s.values.any((v) => v != null))
        .length;

    return BlocListener<RegistrationCubit, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationSubmitSuccess) {
          setState(_selections.clear);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Courses registered successfully.'),
              backgroundColor: AppColors.success,
            ),
          );
        }

        if (state is RegistrationSubmitFailure) {
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
          title: const Text('Course registration'),
        ),
        body: BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            if (state is RegistrationLoading ||
                state is RegistrationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RegistrationLoadFailure) {
              return AppEmpty(
                icon: Icons.wifi_off_rounded,
                message: state.message,
                actionText: 'Retry',
                onAction: () =>
                    context.read<RegistrationCubit>().getAvailableCourses(),
              );
            }

            // Submitting / success / failure keep the previously loaded
            // list on screen, so fall through to it below.
            final loaded = state is RegistrationLoaded
                ? state
                : context.read<RegistrationCubit>().state
            as RegistrationLoaded?;

            final courses = loaded?.availableCourses ?? [];

            if (courses.isEmpty) {
              return const AppEmpty(
                icon: Icons.event_available_rounded,
                message: 'No courses are open for registration right now.',
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<RegistrationCubit>().getAvailableCourses(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                itemCount: courses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final availableCourse = courses[index];
                  final courseId = availableCourse.course.id;

                  return CourseSelectionCard(
                    availableCourse: availableCourse,
                    selection: _selections[courseId] ?? const {},
                    onSectionSelected: (type, sectionId) =>
                        _onSectionSelected(courseId, type, sectionId),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar:
        BlocBuilder<RegistrationCubit, RegistrationState>(
          builder: (context, state) {
            final submitting = state is RegistrationSubmitting;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: submitting ? null : () => _submit(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: submitting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      selectedCourseCount == 0
                          ? 'Register'
                          : 'Register ($selectedCourseCount courses)',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
