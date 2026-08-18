import '../models/course_material_model.dart';

abstract class CourseMaterialRemoteDataSource {
  Future<List<CourseMaterialModel>> getMaterials(int courseSectionId);
}
