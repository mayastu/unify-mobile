import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/repositories/student_repository.dart';
import 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository repository;

  StudentCubit(this.repository) : super(StudentInitial());

  Future<void> getProfile() async {
    emit(StudentLoading());

    try {
      final student = await repository.getProfile();

      await SecureStorage.saveStudentId(student.id);

      emit(StudentSuccess(student));
    } catch (e) {
      emit(StudentFailure(e.toString()));
    }
  }
}