import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/classroom_repository.dart';
import 'classroom_state.dart';

class ClassroomCubit extends Cubit<ClassroomState> {
  final ClassroomRepository repository;

  ClassroomCubit(this.repository) : super(ClassroomInitial());

  Future<void> getClassrooms() async {
    emit(ClassroomLoading());

    try {
      final classrooms = await repository.getClassrooms();

      emit(ClassroomSuccess(classrooms));
    } catch (e) {
      emit(ClassroomFailure(e.toString()));
    }
  }
}
