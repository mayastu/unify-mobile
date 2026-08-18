import 'dart:convert';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? screen;
  final dynamic payload;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.screen,
    this.payload,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      screen: json['screen']?.toString(),
      payload: json['payload'],
      isRead: json['is_read'] ?? false,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      screen: screen,
      payload: payload,
      isRead: isRead ?? this.isRead,
      readAt: readAt,
      createdAt: createdAt,
    );
  }

  /// The API docs list `payload` inconsistently (a plain string in one
  /// place, "string or array" in another). This normalizes the common
  /// real-world case — a JSON-encoded object — without crashing on any
  /// other shape it might actually come back as.
  Map<String, dynamic>? get payloadMap {
    if (payload is Map<String, dynamic>) return payload as Map<String, dynamic>;

    if (payload is String && (payload as String).isNotEmpty) {
      try {
        final decoded = jsonDecode(payload as String);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        // Not JSON — leave it null, callers just won't get extra data.
      }
    }

    return null;
  }
}