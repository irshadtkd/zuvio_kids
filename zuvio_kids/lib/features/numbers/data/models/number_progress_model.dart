import 'dart:convert';
import 'package:zuvio_kids/features/numbers/domain/entities/number_progress_entity.dart';

/// DTO for serialising/deserialising numbers session completion to/from local storage.
/// Layer: Data
class NumberProgressModel extends NumberProgressEntity {
  const NumberProgressModel({
    required super.studentName,
    required super.completedSessionIds,
    required super.totalStars,
  });

  factory NumberProgressModel.fromJson(Map<String, dynamic> json) {
    final completedList = (json['completedSessionIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};

    return NumberProgressModel(
      studentName: json['studentName'] as String? ?? '',
      completedSessionIds: completedList,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
    );
  }

  factory NumberProgressModel.fromEntity(NumberProgressEntity entity) {
    return NumberProgressModel(
      studentName: entity.studentName,
      completedSessionIds: entity.completedSessionIds,
      totalStars: entity.totalStars,
    );
  }

  Map<String, dynamic> toJson() => {
        'studentName': studentName,
        'completedSessionIds': completedSessionIds.toList(),
        'totalStars': totalStars,
      };

  String serialize() => jsonEncode(toJson());

  static NumberProgressModel? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return NumberProgressModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
