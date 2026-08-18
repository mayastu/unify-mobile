import 'course_material_repository.dart';
import '../data_source/course_material_remote_datasource.dart';
import '../models/course_material_model.dart';

class CourseMaterialRepositoryImpl implements CourseMaterialRepository {
  final CourseMaterialRemoteDataSource remote;

  CourseMaterialRepositoryImpl(this.remote);

  @override
  Future<List<CourseMaterialModel>> getMaterials(int courseSectionId) =>
      remote.getMaterials(courseSectionId);
}
