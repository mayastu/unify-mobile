import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/service_locator.dart';
import '../cubit/grade_objection_cubit.dart';

/// Bottom sheet for objecting to a single graded component. Loads
/// eligibility first (a component may already have a pending
/// objection, disallow resubmission, or belong to a course with
/// objections turned off), then shows either the reason it's blocked
/// or a form to submit one.
class ObjectionSheet extends StatelessWidget {
  const ObjectionSheet({
    super.key,
    required this.studentGradeId,
    required this.componentName,
  });

  final int studentGradeId;
  final String componentName;

  static Future<void> show(
    BuildContext context, {
    required int studentGradeId,
    required String componentName,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) =>
            sl<GradeObjectionCubit>()..checkEligibility(studentGradeId),
        child: ObjectionSheet(
          studentGradeId: studentGradeId,
          componentName: componentName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: BlocConsumer<GradeObjectionCubit, GradeObjectionState>(
            listener: (context, state) {
              if (state is GradeObjectionSubmitSuccess) {
                Navigator.of(context).pop();
                AppSnackBar.success(context, 'Objection submitted successfully.');
              } else if (state is GradeObjectionSubmitFailure) {
                AppSnackBar.error(context, state.message);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Text(
                    'Object to grade',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    componentName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Body(state: state, studentGradeId: studentGradeId),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.state, required this.studentGradeId});

  final GradeObjectionState state;
  final int studentGradeId;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    if (state is GradeObjectionEligibilityLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // The sheet is being popped by the listener right now — render
    // nothing rather than fall through to the eligibility cast below.
    if (state is GradeObjectionSubmitSuccess) {
      return const SizedBox.shrink();
    }

    if (state is GradeObjectionEligibilityFailure) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context
                  .read<GradeObjectionCubit>()
                  .checkEligibility(widget.studentGradeId),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final eligibility = state is GradeObjectionEligibilityLoaded
        ? state.eligibility
        : state is GradeObjectionSubmitting
            ? state.eligibility
            : (state as GradeObjectionSubmitFailure).eligibility;

    if (!eligibility.courseObjectionsEnabled) {
      return const _BlockedMessage(
        icon: Icons.block_rounded,
        message: 'Objections are not enabled for this course.',
      );
    }

    if (!eligibility.canSubmit) {
      return _BlockedMessage(
        icon: Icons.info_outline_rounded,
        message: eligibility.reasonMessage ??
            'You can\'t submit an objection for this grade right now.',
      );
    }

    final isSubmitting = state is GradeObjectionSubmitting;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _detailsController,
            hintText: 'Explain why you\'re objecting to this grade '
                '(min. 10 characters)',
            maxLines: 5,
            maxLength: 3000,
            validator: (value) {
              final length = value?.trim().length ?? 0;
              if (length < 10) {
                return 'Please enter at least 10 characters.';
              }
              if (length > 3000) {
                return 'Details can be at most 3000 characters.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Submit objection',
            isLoading: isSubmitting,
            onPressed: () {
              if (_formKey.currentState?.validate() != true) return;

              context.read<GradeObjectionCubit>().submit(
                    studentGradeId: widget.studentGradeId,
                    details: _detailsController.text.trim(),
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _BlockedMessage extends StatelessWidget {
  const _BlockedMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
