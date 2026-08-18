import '../models/course_material_model.dart';

abstract class CourseMaterialRepository {
  Future<List<CourseMaterialModel>> getMaterials(int courseSectionId);
}
