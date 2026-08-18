import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/attendance_repository.dart';
import 'attendance_summary_state.dart';

class AttendanceSummaryCubit extends Cubit<AttendanceSummaryState> {
  final AttendanceRepository repository;

  AttendanceSummaryCubit(this.repository) : super(AttendanceSummaryLoading());

  Future<void> load(int studentCourseId) async {
    emit(AttendanceSummaryLoading());
    try {
      final summary = await repository.getAttendanceSummary(studentCourseId);
      emit(AttendanceSummarySuccess(summary));
    } catch (e) {
      emit(AttendanceSummaryFailure(e.toString()));
    }
  }
}
