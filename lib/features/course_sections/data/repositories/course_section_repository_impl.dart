import 'course_section_repository.dart';
import '../data_source/course_section_remote_datasource.dart';
import '../models/course_section_model.dart';

class CourseSectionRepositoryImpl implements CourseSectionRepository {
  final CourseSectionRemoteDataSource remote;

  CourseSectionRepositoryImpl(this.remote);

  @override
  Future<List<CourseSectionModel>> getCourseSections() {
    return remote.getCourseSections();
  }
}
