import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/grade_objection_eligibility_model.dart';
import '../../data/repositories/grade_objection_repository.dart';

abstract class GradeObjectionState {}

class GradeObjectionEligibilityLoading extends GradeObjectionState {}

class GradeObjectionEligibilityFailure extends GradeObjectionState {
  final String message;

  GradeObjectionEligibilityFailure(this.message);
}

/// Base for every state that already has an eligibility result, so
/// the sheet can keep showing "why you can't object" / the form
/// while a submission is in flight or after it fails.
abstract class _WithEligibility extends GradeObjectionState {
  final GradeObjectionEligibilityModel eligibility;

  _WithEligibility(this.eligibility);
}

class GradeObjectionEligibilityLoaded extends _WithEligibility {
  GradeObjectionEligibilityLoaded(super.eligibility);
}

class GradeObjectionSubmitting extends _WithEligibility {
  GradeObjectionSubmitting(super.eligibility);
}

class GradeObjectionSubmitSuccess extends GradeObjectionState {}

class GradeObjectionSubmitFailure extends _WithEligibility {
  final String message;

  GradeObjectionSubmitFailure(super.eligibility, this.message);
}

/// Drives one objection bottom sheet: check whether the student can
/// object to a given graded component, then submit the objection.
/// Short-lived — created fresh per sheet, not shared app-wide state.
class GradeObjectionCubit extends Cubit<GradeObjectionState> {
  final GradeObjectionRepository repository;

  GradeObjectionCubit(this.repository) : super(GradeObjectionEligibilityLoading());

  Future<void> checkEligibility(int studentGradeId) async {
    emit(GradeObjectionEligibilityLoading());

    try {
      final eligibility = await repository.getEligibility(studentGradeId);
      emit(GradeObjectionEligibilityLoaded(eligibility));
    } catch (e) {
      emit(GradeObjectionEligibilityFailure(e.toString()));
    }
  }

  Future<void> submit({
    required int studentGradeId,
    required String details,
  }) async {
    final current = state;
    if (current is! _WithEligibility) return;

    emit(GradeObjectionSubmitting(current.eligibility));

    try {
      await repository.submitObjection(
        studentGradeId: studentGradeId,
        details: details,
      );
      emit(GradeObjectionSubmitSuccess());
    } catch (e) {
      emit(GradeObjectionSubmitFailure(current.eligibility, e.toString()));
    }
  }
}
