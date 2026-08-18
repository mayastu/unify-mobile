import '../../data/models/course_material_model.dart';
import '../../data/models/material_download_status.dart';

abstract class CourseMaterialState {
  const CourseMaterialState({
    this.items = const [],
    this.downloads = const {},
  });

  final List<CourseMaterialModel> items;

  /// Keyed by `CourseMaterialModel.id`.
  final Map<int, MaterialDownloadStatus> downloads;
}

class CourseMaterialLoading extends CourseMaterialState {
  const CourseMaterialLoading();
}

class CourseMaterialLoaded extends CourseMaterialState {
  const CourseMaterialLoaded({required super.items, required super.downloads});
}

class CourseMaterialFailure extends CourseMaterialState {
  const CourseMaterialFailure(this.message, {super.items, super.downloads});

  final String message;
}
