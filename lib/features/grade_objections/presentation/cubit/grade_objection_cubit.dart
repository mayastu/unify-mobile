import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/grade_objection_eligibility_model.dart';
import '../../data/repositories/grade_objection_repository.dart';

abstract class GradeObjectionState {}

/// Initial state when the bottom sheet is opened.
class GradeObjectionInitial extends GradeObjectionState {}

/// Checking whether the student is allowed to submit
/// an objection for this specific grade.
class GradeObjectionEligibilityLoading
    extends GradeObjectionState {}

/// Eligibility request failed.
class GradeObjectionEligibilityFailure
    extends GradeObjectionState {
  final String message;

  GradeObjectionEligibilityFailure(this.message);
}

/// Base state containing an already-loaded eligibility result.
///
/// This allows the sheet to keep showing the eligibility result
/// while submitting or after a submission failure.
abstract class _WithEligibility
    extends GradeObjectionState {
  final GradeObjectionEligibilityModel eligibility;

  _WithEligibility(this.eligibility);
}

/// Eligibility loaded successfully.
class GradeObjectionEligibilityLoaded
    extends _WithEligibility {
  GradeObjectionEligibilityLoaded(
      super.eligibility,
      );
}

/// Objection is being submitted.
class GradeObjectionSubmitting
    extends _WithEligibility {
  GradeObjectionSubmitting(
      super.eligibility,
      );
}

/// Objection submitted successfully.
class GradeObjectionSubmitSuccess
    extends GradeObjectionState {}

/// Objection submission failed.
///
/// We keep the eligibility object so the UI doesn't
/// lose the form/blocked state after an API error.
class GradeObjectionSubmitFailure
    extends _WithEligibility {
  final String message;

  GradeObjectionSubmitFailure(
      super.eligibility,
      this.message,
      );
}


class GradeObjectionCubit
    extends Cubit<GradeObjectionState> {
  final GradeObjectionRepository repository;

  GradeObjectionCubit(this.repository)
      : super(GradeObjectionInitial());

  /// Checks whether the current student can submit
  /// an objection for this specific grade.
  Future<void> checkEligibility(
      int studentGradeId,
      ) async {
    emit(GradeObjectionEligibilityLoading());

    try {
      final eligibility =
      await repository.getEligibility(
        studentGradeId,
      );

      emit(
        GradeObjectionEligibilityLoaded(
          eligibility,
        ),
      );
    } catch (e) {
      emit(
        GradeObjectionEligibilityFailure(
          e.toString(),
        ),
      );
    }
  }

  /// Submits an objection for the selected grade.
  Future<void> submit({
    required int studentGradeId,
    required String details,
  }) async {
    final current = state;

    if (current is! _WithEligibility) {
      return;
    }

    emit(
      GradeObjectionSubmitting(
        current.eligibility,
      ),
    );

    try {
      await repository.submitObjection(
        studentGradeId: studentGradeId,
        details: details,
      );

      emit(
        GradeObjectionSubmitSuccess(),
      );
    } catch (e) {
      emit(
        GradeObjectionSubmitFailure(
          current.eligibility,
          e.toString(),
        ),
      );
    }
  }
}