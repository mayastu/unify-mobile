import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unify/features/semesters/presentation/cubit/semester_state.dart';

import '../../data/repositories/semester_repository.dart';

class SemesterCubit extends Cubit<SemesterState> {
  final SemesterRepository repository;

  SemesterCubit(this.repository)
      : super(SemesterInitial());

  Future<void> getSemesters() async {
    emit(SemesterLoading());

    try {
      final semesters = await repository.getSemesters();

      emit(SemesterSuccess(semesters));
    } catch (e) {
      emit(SemesterFailure(e.toString()));
    }
  }
}