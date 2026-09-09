import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../di/service_locator.dart';
import '../../data/models/grade_objection_eligibility_model.dart';
import '../../data/models/grade_objection_model.dart';
import '../cubit/grade_objection_cubit.dart';

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
      builder: (_) {
        return BlocProvider(
          create: (_) => sl<GradeObjectionCubit>()
            ..checkEligibility(studentGradeId),

          child: ObjectionSheet(
            studentGradeId: studentGradeId,
            componentName: componentName,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),

      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20,
        ),

        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),

        child: SafeArea(
          top: false,

          child: BlocConsumer<
              GradeObjectionCubit,
              GradeObjectionState>(
            listener: (context, state) {
              if (state is GradeObjectionSubmitSuccess) {
                Navigator.of(context).pop();

                AppSnackBar.success(
                  context,
                  'Objection submitted successfully.',
                );
              }

              if (state is GradeObjectionSubmitFailure) {
                AppSnackBar.error(
                  context,
                  state.message,
                );
              }
            },

            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(
                        bottom: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary
                              .withOpacity(.10),
                          borderRadius:
                          BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.gavel_rounded,
                          color: AppColors.primary,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Object to grade',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                                color:
                                AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              componentName,
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color:
                                AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  _ObjectionBody(
                    state: state,
                    studentGradeId: studentGradeId,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ObjectionBody extends StatefulWidget {
  const _ObjectionBody({
    required this.state,
    required this.studentGradeId,
  });

  final GradeObjectionState state;
  final int studentGradeId;

  @override
  State<_ObjectionBody> createState() =>
      _ObjectionBodyState();
}

class _ObjectionBodyState
    extends State<_ObjectionBody> {
  final _formKey = GlobalKey<FormState>();

  final _detailsController =
  TextEditingController();

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    // ------------------------------------------------------------
    // Checking eligibility
    // ------------------------------------------------------------

    if (state is GradeObjectionEligibilityLoading ||
        state is GradeObjectionInitial) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // Eligibility request failed
    // ------------------------------------------------------------

    if (state is GradeObjectionEligibilityFailure) {
      return _ErrorState(
        message: state.message,
        onRetry: () {
          context
              .read<GradeObjectionCubit>()
              .checkEligibility(
            widget.studentGradeId,
          );
        },
      );
    }

    // ------------------------------------------------------------
    // Submit succeeded
    // ------------------------------------------------------------

    if (state is GradeObjectionSubmitSuccess) {
      return const SizedBox.shrink();
    }

    // ------------------------------------------------------------
    // Get eligibility safely
    // ------------------------------------------------------------

    GradeObjectionEligibilityModel? eligibility;

    if (state is GradeObjectionEligibilityLoaded) {
      eligibility = state.eligibility;
    } else if (state is GradeObjectionSubmitting) {
      eligibility = state.eligibility;
    } else if (state is GradeObjectionSubmitFailure) {
      eligibility = state.eligibility;
    }

    if (eligibility == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    // ------------------------------------------------------------
    // Objections disabled for course
    // ------------------------------------------------------------

    if (!eligibility.courseObjectionsEnabled) {
      return const _BlockedMessage(
        icon: Icons.lock_outline_rounded,
        title: 'Objections are closed',
        message:
        'Grade objections are not currently enabled '
            'for this course.',
      );
    }

    // ------------------------------------------------------------
    // Student cannot submit
    // ------------------------------------------------------------

    if (!eligibility.canSubmit) {
      return _BlockedMessage(
        icon: Icons.info_outline_rounded,
        title: 'You can’t submit an objection',
        message: eligibility.reasonMessage ??
            'You cannot submit an objection for '
                'this grade right now.',
      );
    }

    // ------------------------------------------------------------
    // Allowed
    // ------------------------------------------------------------

    final isSubmitting =
    state is GradeObjectionSubmitting;

    return _ObjectionForm(
      formKey: _formKey,
      controller: _detailsController,
      isSubmitting: isSubmitting,
      onSubmit: () {
        if (_formKey.currentState?.validate() !=
            true) {
          return;
        }

        context
            .read<GradeObjectionCubit>()
            .submit(
          studentGradeId:
          widget.studentGradeId,
          details:
          _detailsController.text.trim(),
        );
      },
    );
  }
}

class _ObjectionForm extends StatelessWidget {
  const _ObjectionForm({
    required this.formKey,
    required this.controller,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
              AppColors.primary.withOpacity(.06),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),

                SizedBox(width: 8),

                Expanded(
                  child: Text(
                    'Explain clearly why you believe '
                        'this grade should be reviewed.',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          AppTextField(
            controller: controller,
            hintText:
            'Explain why you\'re objecting to '
                'this grade (min. 10 characters)',
            maxLines: 5,
            maxLength: 3000,
            validator: (value) {
              final length =
                  value?.trim().length ?? 0;

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
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _BlockedMessage extends StatelessWidget {
  const _BlockedMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.border,
          ),
        ),

        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color:
                AppColors.textSecondary
                    .withOpacity(.10),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                AppColors.textSecondary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),

      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 27,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 10),

          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}