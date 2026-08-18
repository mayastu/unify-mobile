import '../../data/models/grade_breakdown_model.dart';

abstract class GradeBreakdownState {}

class GradeBreakdownLoading extends GradeBreakdownState {}

class GradeBreakdownFailure extends GradeBreakdownState {
  final String message;

  GradeBreakdownFailure(this.message);
}

/// No grading scheme has been published for this course under any
/// section type yet (all three came back empty). Not an error.
class GradeBreakdownEmpty extends GradeBreakdownState {}

class GradeBreakdownSuccess extends GradeBreakdownState {
  /// One entry per section type that actually has components
  /// published (a course may have just "theory", or "theory" +
  /// "practical", etc.).
  final List<GradeSectionBreakdownModel> sections;

  GradeBreakdownSuccess(this.sections);
}
