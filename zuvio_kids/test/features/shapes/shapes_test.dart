import 'package:flutter_test/flutter_test.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_data.dart';
import 'package:zuvio_kids/features/shapes/data/datasources/shape_local_datasource.dart';
import 'package:zuvio_kids/features/shapes/data/models/shape_progress_model.dart';
import 'package:zuvio_kids/features/shapes/data/repositories/shape_repository_impl.dart';

class _MockShapeLocalDataSource implements ShapeLocalDataSource {
  ShapeProgressModel? progress;

  @override
  Future<ShapeProgressModel?> getProgress(String studentName) async {
    return progress;
  }

  @override
  Future<void> saveProgress(ShapeProgressModel model) async {
    progress = model;
  }

  @override
  Future<void> clearProgress(String studentName) async {
    progress = null;
  }

  @override
  Future<void> clearAll() async {
    progress = null;
  }
}

void main() {
  group('Shapes Data Catalog Tests', () {
    test('contains all 12 shapes across 4 sessions', () {
      final defaultSessions = ShapeData.getDefaultSessions();
      expect(defaultSessions.length, 4);

      expect(defaultSessions[0].shapes.map((s) => s.id).toList(),
          ['circle', 'square', 'triangle']);
      expect(defaultSessions[1].shapes.map((s) => s.id).toList(),
          ['rectangle', 'oval', 'star']);
      expect(defaultSessions[2].shapes.map((s) => s.id).toList(),
          ['heart', 'diamond', 'pentagon']);
      expect(defaultSessions[3].shapes.map((s) => s.id).toList(),
          ['hexagon', 'crescent', 'semicircle']);

      for (final shape in ShapeData.allShapes) {
        expect(shape.strokes.isNotEmpty, isTrue);
        expect(shape.strokes.first.points.isNotEmpty, isTrue);
        expect(shape.quizOptionIds.length, 3);
        expect(shape.quizOptionIds.contains(shape.id), isTrue);
      }
    });
  });

  group('Shapes Progress Model Tests', () {
    test('serializes and deserializes accurately', () {
      const model = ShapeProgressModel(
        studentName: 'Aarav',
        completedSessionIds: ['session_1'],
        unlockedSessionIds: ['session_1', 'session_2'],
        totalStars: 10,
      );

      final raw = model.serialize();
      final restored = ShapeProgressModel.deserialize(raw);

      expect(restored, isNotNull);
      expect(restored!.studentName, 'Aarav');
      expect(restored.completedSessionIds, ['session_1']);
      expect(restored.unlockedSessionIds, ['session_1', 'session_2']);
      expect(restored.totalStars, 10);
    });
  });

  group('Shapes Repository Tests', () {
    test('Session 1 is unlocked by default, session 2 unlocked when session 1 completes',
        () async {
      final mockDs = _MockShapeLocalDataSource();
      final repository = ShapeRepositoryImpl(mockDs);

      // Initially
      final initialSessionsResult = await repository.getSessions('Aarav');
      final initialSessions = initialSessionsResult.getOrElse((_) => []);

      expect(initialSessions[0].isLocked, isFalse);
      expect(initialSessions[1].isLocked, isTrue);

      // Complete session 1
      final completeResult =
          await repository.completeSession('Aarav', 'session_1');
      expect(completeResult.isRight(), isTrue);

      // Check sessions again
      final updatedSessionsResult = await repository.getSessions('Aarav');
      final updatedSessions = updatedSessionsResult.getOrElse((_) => []);

      expect(updatedSessions[0].isCompleted, isTrue);
      expect(updatedSessions[0].starsEarned, 10);
      expect(updatedSessions[1].isLocked, isFalse);

      // Complete session 1 again - duplicate star prevention
      await repository.completeSession('Aarav', 'session_1');
      final progressResult = await repository.getProgress('Aarav');
      final progress = progressResult.getOrElse(
        (_) => throw Exception('failed to get progress'),
      );
      expect(progress.totalStars, 10);
    });
  });
}
