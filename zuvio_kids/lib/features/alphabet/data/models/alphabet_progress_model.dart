import 'dart:convert';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_progress_entity.dart';

/// DTO for serialising/deserialising alphabet session completion to/from local storage.
/// Layer: Data
class AlphabetProgressModel extends AlphabetProgressEntity {
  const AlphabetProgressModel({
    required super.studentName,
    required super.completedSessionIds,
    required super.totalStars,
  });

  factory AlphabetProgressModel.fromJson(Map<String, dynamic> json) {
    final completedList = (json['completedSessionIds'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toSet() ??
        <String>{};

    return AlphabetProgressModel(
      studentName: json['studentName'] as String? ?? '',
      completedSessionIds: completedList,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
    );
  }

  factory AlphabetProgressModel.fromEntity(AlphabetProgressEntity entity) {
    return AlphabetProgressModel(
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

  static AlphabetProgressModel? deserialize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AlphabetProgressModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
