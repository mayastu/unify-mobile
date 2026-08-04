import '../../data/models/schedule_entry_model.dart';

abstract class StudentScheduleState {}

class StudentScheduleInitial extends StudentScheduleState {}

class StudentScheduleLoading extends StudentScheduleState {}

class StudentScheduleSuccess extends StudentScheduleState {
  final Map<String, List<ScheduleEntryModel>> schedule;

  StudentScheduleSuccess(this.schedule);
}

class StudentScheduleFailure extends StudentScheduleState {
  final String message;

  StudentScheduleFailure(this.message);
}
