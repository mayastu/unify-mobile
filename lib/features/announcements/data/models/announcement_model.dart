/// One announcement (`AnnouncementResource`) as returned by
/// `GET /api/announcements` (and `/api/announcements/{id}`). This is
/// the read-only, student-facing shape — publishing/editing/deleting
/// happens on the instructor/admin side and isn't part of this model.
class AnnouncementModel {
  final String id;
  final String title;
  final String body;

  /// e.g. "none" / "image" / "video" / "file" — kept as a raw string
  /// since the docs don't enumerate the allowed values. [hasMedia] and
  /// [isImage] below cover the two cases the UI actually branches on.
  final String mediaType;
  final String? mediaUrl;

  final String authorId;
  final String authorName;

  final String audienceType;

  final int recipientsCount;
  final String publishedAt;
  final String updatedAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.mediaType,
    required this.mediaUrl,
    required this.authorId,
    required this.authorName,
    required this.audienceType,
    required this.recipientsCount,
    required this.publishedAt,
    required this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? const {};
    final audience = json['audience'] as Map<String, dynamic>? ?? const {};
    final url = json['media_url']?.toString();

    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      mediaType: json['media_type']?.toString() ?? 'none',
      mediaUrl: (url == null || url.isEmpty) ? null : url,
      authorId: author['id']?.toString() ?? '',
      authorName: author['name']?.toString() ?? '',
      audienceType: audience['type']?.toString() ?? '',
      recipientsCount: _asInt(json['recipients_count']),
      publishedAt: json['published_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  bool get hasMedia => mediaUrl != null && mediaType.toLowerCase() != 'none';

  bool get isImage => hasMedia && mediaType.toLowerCase() == 'image';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
