import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unify/features/grades/presentation/cubit/grades_state.dart';

import '../../data/repositories/grades_repository.dart';

class GradesCubit extends Cubit<GradesState> {
  final GradesRepository repository;

  GradesCubit(this.repository) : super(GradesInitial());

  Future<void> getCurrentSemesterGrades() async {
    emit(GradesLoading());

    try {
      final grades = await repository.getCurrentSemesterGrades();

      emit(GradesSuccess(grades));
    } catch (e) {
      emit(GradesFailure(e.toString()));
    }
  }
}
