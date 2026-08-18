import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/course_material_model.dart';
import '../../data/models/material_download_status.dart';
import '../../data/repositories/course_material_repository.dart';
import '../../data/services/material_download_service.dart';
import 'course_material_state.dart';

class CourseMaterialCubit extends Cubit<CourseMaterialState> {
  final CourseMaterialRepository repository;
  final MaterialDownloadService downloadService;

  CourseMaterialCubit(this.repository, this.downloadService)
      : super(const CourseMaterialLoading());

  Future<void> load(int courseSectionId) async {
    emit(const CourseMaterialLoading());

    try {
      final items = await repository.getMaterials(courseSectionId);

      // Downloads land in the device's public Downloads folder now,
      // not a path this app controls or can reliably re-check next
      // launch (the plugin may rename on a conflict, etc.), so every
      // material simply starts as "not downloaded this session".
      emit(CourseMaterialLoaded(items: items, downloads: const {}));
    } catch (e) {
      emit(CourseMaterialFailure(e.toString()));
    }
  }

  Future<void> download(CourseMaterialModel material) async {
    final current = state;
    if (current is! CourseMaterialLoaded) return;

    _update(current, material.id, const MaterialDownloadStatus.downloading(0));

    try {
      final path = await downloadService.download(
        material,
        onProgress: (progress) {
          final latest = state;
          if (latest is! CourseMaterialLoaded) return;

          _update(
            latest,
            material.id,
            MaterialDownloadStatus.downloading(progress),
          );
        },
      );

      final latest = state;
      if (latest is CourseMaterialLoaded) {
        _update(latest, material.id, MaterialDownloadStatus.downloaded(path));
      }
    } catch (e) {
      final latest = state;
      if (latest is CourseMaterialLoaded) {
        _update(latest, material.id, MaterialDownloadStatus.failed(e.toString()));
      }
    }
  }

  /// Opens an already-downloaded material with the OS default viewer.
  /// Throws if it isn't downloaded yet or the OS can't open it —
  /// callers (the UI) catch this and show a snackbar, same as the
  /// rest of the app reports action failures.
  Future<void> open(CourseMaterialModel material) async {
    final current = state;
    final localPath = current is CourseMaterialLoaded
        ? current.downloads[material.id]?.localPath
        : null;

    if (localPath == null) {
      throw Exception('Download this material first.');
    }

    await downloadService.open(localPath);
  }

  void _update(
    CourseMaterialLoaded current,
    int materialId,
    MaterialDownloadStatus status,
  ) {
    emit(CourseMaterialLoaded(
      items: current.items,
      downloads: {...current.downloads, materialId: status},
    ));
  }
}
