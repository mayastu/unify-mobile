import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';

import '../models/course_material_model.dart';

class MaterialDownloadService {
  final Dio _dio;

  MaterialDownloadService({Dio? dio}) : _dio = dio ?? Dio();

  Future<String> download(
      CourseMaterialModel material, {
        void Function(double progress)? onProgress,
      }) async {
    final url = material.fileUrl;

    if (url == null || url.isEmpty) {
      throw Exception('This material has no file to download.');
    }

    try {
      // Public Downloads/CourseMaterials directory
      final directory = Directory(
        '/storage/emulated/0/Download/CourseMaterials',
      );

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath =
          '${directory.path}/${material.downloadFileName}';

      await _dio.download(
        url,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'application/pdf',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            onProgress?.call(progress);
          }
        },
      );

      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception('Downloaded file was not found.');
      }

      final size = await file.length();

      if (size == 0) {
        throw Exception('Downloaded file is empty.');
      }

      return filePath;
    } on DioException catch (e) {
      throw Exception(
        'Download failed: ${e.message ?? 'Unknown network error'}',
      );
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }

  Future<void> open(String localPath) async {
    final result = await OpenFilex.open(localPath);

    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
  }
}