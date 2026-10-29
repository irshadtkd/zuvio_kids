import 'dart:convert';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_progress_entity.dart';

/// DTO for serialising/deserialising shapes learning progress to/from local storage.
/// Layer: Data
class ShapeProgressModel extends ShapeProgressEntity {
  const ShapeProgressModel({
    required super.studentName,
    required super.completedSessionIds,
    required super.unlockedSessionIds,
    required super.totalStars,
  });

  factory ShapeProgressModel.fromJson(Map<String, dynamic> json) {
    final completedList = (json['completedSessionIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final unlockedList = (json['unlockedSessionIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>['session_1'];

    return ShapeProgressModel(
      studentName: json['studentName'] as String? ?? '',
      completedSessionIds: completedList,
      unlockedSessionIds: unlockedList,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
    );
  }

  factory ShapeProgressModel.fromEntity(ShapeProgressEntity entity) {
    return ShapeProgressModel(
      studentName: entity.studentName,
      completedSessionIds: entity.completedSessionIds,
      unlockedSessionIds: entity.unlockedSessionIds,
      totalStars: entity.totalStars,
    );
  }

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'completedSessionIds': completedSessionIds,
        'unlockedSessionIds': unlockedSessionIds,
        'totalStars': totalStars,
      };

  String serialize() => jsonEncode(toJson());

  static ShapeProgressModel? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return ShapeProgressModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
