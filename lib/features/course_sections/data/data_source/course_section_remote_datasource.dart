import '../models/course_section_model.dart';

abstract class CourseSectionRemoteDataSource {
  Future<List<CourseSectionModel>> getCourseSections();
}
