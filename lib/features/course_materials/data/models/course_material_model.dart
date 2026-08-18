/// One file uploaded by the instructor for a course section
/// (`CourseMaterialResource`). The docs also show a fuller shape with
/// nested `course_section_id`/`instructor_id` resources, but the
/// actual `.../materials` list response only ever sends the flat
/// fields below — everything here is read defensively either way.
class CourseMaterialModel {
  final int id;
  final String title;
  final String filePath;

  /// Absolute, publicly reachable URL to download the file from.
  /// Null on the rare row that has no file attached yet.
  final String? fileUrl;
  final String createdAt;
  final String updatedAt;

  const CourseMaterialModel({
    required this.id,
    required this.title,
    required this.filePath,
    required this.fileUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseMaterialModel.fromJson(Map<String, dynamic> json) {
    final url = json['file_url']?.toString();

    return CourseMaterialModel(
      id: _asInt(json['id']),
      title: json['title']?.toString() ?? '',
      filePath: json['file_path']?.toString() ?? '',
      fileUrl: (url == null || url.isEmpty) ? null : url,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  /// e.g. ".pdf" — read from whichever of file_path/file_url actually
  /// has one, used both for the type icon and the saved filename.
  String get fileExtension {
    final source = filePath.isNotEmpty ? filePath : (fileUrl ?? '');
    final dot = source.lastIndexOf('.');
    if (dot == -1 || dot == source.length - 1) return '';
    return source.substring(dot + 1).toLowerCase();
  }

  /// Filename to save the download under, e.g. "Part 1.pdf" — the
  /// student's own title rather than the randomized storage filename
  /// in [filePath], with just enough sanitizing for a filesystem path.
  String get downloadFileName {
    final base = title.trim().isEmpty ? 'material_$id' : title.trim();
    final safe = base.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return fileExtension.isEmpty ? safe : '$safe.$fileExtension';
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
