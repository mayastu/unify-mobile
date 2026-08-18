import '../../data/models/attendance_summary_model.dart';

abstract class AttendanceSummaryState {}

class AttendanceSummaryLoading extends AttendanceSummaryState {}

class AttendanceSummaryFailure extends AttendanceSummaryState {
  final String message;

  AttendanceSummaryFailure(this.message);
}

class AttendanceSummarySuccess extends AttendanceSummaryState {
  final AttendanceSummaryModel summary;

  AttendanceSummarySuccess(this.summary);
}
