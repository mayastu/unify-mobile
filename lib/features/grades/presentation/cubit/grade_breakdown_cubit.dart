import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/grades_repository.dart';
import 'grade_breakdown_state.dart';

class GradeBreakdownCubit extends Cubit<GradeBreakdownState> {
  final GradesRepository repository;

  GradeBreakdownCubit(this.repository) : super(GradeBreakdownLoading());

  // A course only ever uses a subset of these (e.g. a lecture-only
  // course has just "theory"), so we fetch all three and keep
  // whichever ones actually came back with published components,
  // instead of asking the caller to know the course's shape upfront.
  static const _allSectionTypes = ['theory', 'practical', 'project'];

  Future<void> loadBreakdown(int courseId) async {
    emit(GradeBreakdownLoading());

    try {
      final results = await Future.wait(
        _allSectionTypes.map(
          (sectionType) => repository.getStudentGrades(
            courseId: courseId,
            sectionType: sectionType,
          ),
        ),
      );

      final published = results.where((r) => !r.isEmpty).toList();

      if (published.isEmpty) {
        emit(GradeBreakdownEmpty());
      } else {
        emit(GradeBreakdownSuccess(published));
      }
    } catch (e) {
      emit(GradeBreakdownFailure(e.toString()));
    }
  }
}
