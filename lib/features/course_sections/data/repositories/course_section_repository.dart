import '../models/course_section_model.dart';

abstract class CourseSectionRepository {
  Future<List<CourseSectionModel>> getCourseSections();
}
