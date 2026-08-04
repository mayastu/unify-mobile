import 'course_repository.dart';
import '../data_source/course_remote_datasource.dart';
import '../models/course_model.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remote;

  CourseRepositoryImpl(this.remote);

  @override
  Future<List<CourseModel>> getCourses() {
    return remote.getCourses();
  }

  @override
  Future<CourseModel> getCourse(int id) {
    return remote.getCourse(id);
  }
}
