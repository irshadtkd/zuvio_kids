import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/features/animals/data/datasources/animal_data.dart';
import 'package:zuvio_kids/features/animals/data/datasources/animals_local_datasource.dart';
import 'package:zuvio_kids/features/animals/data/models/animal_session_model.dart';
import 'package:zuvio_kids/features/animals/data/repositories/animals_repository_impl.dart';

class _MockAnimalsLocalDataSource implements AnimalsLocalDataSource {
  bool s1Completed = false;
  bool s2Completed = false;
  int s1Stars = 0;
  int s2Stars = 0;

  @override
  Future<List<AnimalSessionModel>> getSessions() async {
    return AnimalData.createDefaultSessions(
      session1Completed: s1Completed,
      session2Completed: s2Completed,
      session1Stars: s1Stars,
      session2Stars: s2Stars,
    );
  }

  @override
  Future<void> saveSessionCompleted(String sessionId, int stars) async {
    if (sessionId == AppStrings.sessionAnimals1) {
      s1Completed = true;
      s1Stars = stars;
    } else if (sessionId == AppStrings.sessionAnimals2) {
      s2Completed = true;
      s2Stars = stars;
    }
  }

  @override
  Future<void> resetProgress() async {
    s1Completed = false;
    s2Completed = false;
    s1Stars = 0;
    s2Stars = 0;
  }
}

void main() {
  group('Animal Data Catalog & Asset Verification', () {
    test('Session 1 contains exact 10 animals in order', () {
      const s1 = AnimalData.session1Animals;
      expect(s1.length, 10);
      expect(s1.map((a) => a.id).toList(), [
        'elephant',
        'cat',
        'tiger',
        'lion',
        'cow',
        'goat',
        'monkey',
        'dog',
        'hen',
        'horse',
      ]);
    });

    test('Session 2 contains exact 10 animals in order', () {
      const s2 = AnimalData.session2Animals;
      expect(s2.length, 10);
      expect(s2.map((a) => a.id).toList(), [
        'rabbit',
        'parrot',
        'fish',
        'giraffe',
        'zebra',
        'deer',
        'peacock',
        'frog',
        'camel',
        'bear',
      ]);
    });

    test('all 20 animals have valid SVG and audio assets existing on disk', () {
      final allAnimals = [
        ...AnimalData.session1Animals,
        ...AnimalData.session2Animals,
      ];
      expect(allAnimals.length, 20);

      for (final animal in allAnimals) {
        expect(animal.svgAsset.endsWith('.svg'), isTrue);
        expect(animal.nameKey.isNotEmpty, isTrue);
        expect(animal.englishName.isNotEmpty, isTrue);
        expect(animal.soundAssetId.isNotEmpty, isTrue);

        // Verify SVG asset file exists
        final svgFile = File(animal.svgAsset);
        expect(
          svgFile.existsSync(),
          isTrue,
          reason: 'SVG asset ${animal.svgAsset} must exist on disk',
        );

        // Verify Audio WAV file exists
        final audioPath =
            '${AppStrings.assetsAudio}animals/${animal.soundAssetId}.wav';
        final audioFile = File(audioPath);
        expect(
          audioFile.existsSync(),
          isTrue,
          reason: 'Audio asset $audioPath must exist on disk',
        );
      }
    });
  });

  group('Animals Repository & Progress', () {
    test('Session 1 is unlocked initially, Session 2 unlocks upon completing Session 1',
        () async {
      final mockDs = _MockAnimalsLocalDataSource();
      final repository = AnimalsRepositoryImpl(mockDs);

      // Initial check
      final initialResult = await repository.getSessions();
      final initialSessions = initialResult.getOrElse((_) => []);
      expect(initialSessions.length, 2);
      expect(initialSessions[0].isLocked, isFalse);
      expect(initialSessions[0].isCompleted, isFalse);
      expect(initialSessions[1].isLocked, isTrue);
      expect(initialSessions[1].isCompleted, isFalse);

      // Complete Session 1
      final saveResult = await repository.saveSessionCompleted(
        AppStrings.sessionAnimals1,
        5,
      );
      expect(saveResult.isRight(), isTrue);

      // Updated check
      final updatedResult = await repository.getSessions();
      final updatedSessions = updatedResult.getOrElse((_) => []);
      expect(updatedSessions[0].isCompleted, isTrue);
      expect(updatedSessions[0].starsEarned, 5);
      expect(updatedSessions[1].isLocked, isFalse);

      // Reset check
      await repository.resetProgress();
      final resetResult = await repository.getSessions();
      final resetSessions = resetResult.getOrElse((_) => []);
      expect(resetSessions[0].isCompleted, isFalse);
      expect(resetSessions[1].isLocked, isTrue);
    });
  });
}
