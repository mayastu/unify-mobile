import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/course_section_repository.dart';
import 'course_section_state.dart';

class CourseSectionCubit extends Cubit<CourseSectionState> {
  final CourseSectionRepository repository;

  CourseSectionCubit(this.repository) : super(CourseSectionInitial());

  Future<void> getCourseSections() async {
    emit(CourseSectionLoading());

    try {
      final sections = await repository.getCourseSections();

      emit(CourseSectionSuccess(sections));
    } catch (e) {
      emit(CourseSectionFailure(e.toString()));
    }
  }
}
