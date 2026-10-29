import 'dart:convert';
import 'package:zuvio_kids/features/colors/domain/entities/color_progress_entity.dart';

/// DTO for serialising/deserialising Colors session completion to/from local storage.
/// Layer: Data
class ColorProgressModel extends ColorProgressEntity {
  const ColorProgressModel({
    required super.studentName,
    required super.isCompleted,
    required super.totalStars,
  });

  factory ColorProgressModel.fromJson(Map<String, dynamic> json) {
    return ColorProgressModel(
      studentName: json['studentName'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
    );
  }

  factory ColorProgressModel.fromEntity(ColorProgressEntity entity) {
    return ColorProgressModel(
      studentName: entity.studentName,
      isCompleted: entity.isCompleted,
      totalStars: entity.totalStars,
    );
  }

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'isCompleted': isCompleted,
        'totalStars': totalStars,
      };

  String serialize() => jsonEncode(toJson());

  static ColorProgressModel? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return ColorProgressModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
