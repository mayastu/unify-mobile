import '../../data/models/course_section_model.dart';

abstract class CourseSectionState {}

class CourseSectionInitial extends CourseSectionState {}

class CourseSectionLoading extends CourseSectionState {}

class CourseSectionSuccess extends CourseSectionState {
  final List<CourseSectionModel> sections;

  CourseSectionSuccess(this.sections);
}

class CourseSectionFailure extends CourseSectionState {
  final String message;

  CourseSectionFailure(this.message);
}
