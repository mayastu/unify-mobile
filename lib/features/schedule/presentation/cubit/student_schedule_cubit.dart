import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/student_schedule_repository.dart';
import 'student_schedule_state.dart';

class StudentScheduleCubit extends Cubit<StudentScheduleState> {
  final StudentScheduleRepository repository;

  StudentScheduleCubit(this.repository) : super(StudentScheduleInitial());

  Future<void> getSchedule() async {
    emit(StudentScheduleLoading());

    try {
      final schedule = await repository.getStudentSchedule();

      emit(StudentScheduleSuccess(schedule));
    } catch (e) {
      emit(StudentScheduleFailure(e.toString()));
    }
  }
}
