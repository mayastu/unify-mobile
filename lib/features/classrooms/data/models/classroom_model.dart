class ClassroomModel {
  final int id;
  final String name;
  final String building;
  final int floor;
  final int capacity;
  final String createdAt;

  const ClassroomModel({
    required this.id,
    required this.name,
    required this.building,
    required this.floor,
    required this.capacity,
    required this.createdAt,
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    return ClassroomModel(
      id: json['id'],
      name: json['name'] ?? '',
      building: json['building'] ?? '',
      floor: _asInt(json['floor']),
      capacity: _asInt(json['capacity']),
      createdAt: json['created_at'] ?? '',
    );
  }

  /// The docs describe `floor`/`capacity` as strings in the schema, but
  /// the live server returns numbers. Accept either.
  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
