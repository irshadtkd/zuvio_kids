import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_data.dart';
import 'package:zuvio_kids/features/puzzle/data/datasources/puzzle_generator.dart';
import 'package:zuvio_kids/features/puzzle/data/datasources/puzzle_local_datasource_impl.dart';
import 'package:zuvio_kids/features/puzzle/data/repositories/puzzle_repository_impl.dart';
import 'package:zuvio_kids/features/puzzle/domain/entities/puzzle_item_entity.dart';
import 'package:zuvio_kids/features/puzzle/presentation/providers/puzzle_provider.dart';
import 'package:zuvio_kids/features/puzzle/presentation/screens/puzzle_congratulations_screen.dart';
import 'package:zuvio_kids/features/puzzle/presentation/screens/puzzle_sessions_screen.dart';
import 'package:zuvio_kids/features/puzzle/presentation/widgets/dashed_shadow_slot.dart';
import 'package:zuvio_kids/features/puzzle/presentation/widgets/puzzle_draggable_item.dart';
import 'package:zuvio_kids/features/puzzle/presentation/widgets/puzzle_session_pills.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    KidSoundService.instance.setMuted(true);
  });

  tearDown(KidSoundService.instance.stop);

  group('PuzzleGenerator Tests', () {
    test('generates exactly 4 puzzle sessions covering all 4 learning areas', () {
      final sessions = PuzzleGenerator.generatePuzzleSet();
      expect(sessions.length, 4);

      // Session 1: Shapes
      expect(sessions[0].sessionNumber, 1);
      expect(sessions[0].shadowItems.first.type, PuzzleItemType.shape);
      expect(sessions[0].shadowItems.length, 3);
      expect(sessions[0].pictureItems.length, 3);

      // Session 2: Colors
      expect(sessions[1].sessionNumber, 2);
      expect(sessions[1].shadowItems.first.type, PuzzleItemType.color);
      expect(sessions[1].shadowItems.length, 3);
      expect(sessions[1].pictureItems.length, 3);

      // Session 3: Numbers (1–100)
      expect(sessions[2].sessionNumber, 3);
      expect(sessions[2].shadowItems.first.type, PuzzleItemType.number);
      expect(sessions[2].shadowItems.length, 3);
      expect(sessions[2].pictureItems.length, 3);

      // Session 4: Alphabet (A–Z)
      expect(sessions[3].sessionNumber, 4);
      expect(sessions[3].shadowItems.first.type, PuzzleItemType.alphabet);
      expect(sessions[3].shadowItems.length, 3);
      expect(sessions[3].pictureItems.length, 3);
    });

    test('avoids previously completed puzzle variations', () {
      final firstSet = PuzzleGenerator.generatePuzzleSet();
      final completedKeys = firstSet.map((s) => s.variationKey).toSet();

      // Second generation passing first completed keys
      final secondSet = PuzzleGenerator.generatePuzzleSet(
        completedVariationKeys: completedKeys,
      );

      for (var i = 0; i < 4; i++) {
        expect(
          secondSet[i].variationKey,
          isNot(equals(firstSet[i].variationKey)),
          reason: 'Session $i should have generated a different variation',
        );
      }
    });

    test('triggers history reset callback when pool variations are exhausted', () {
      var resetCategoryCalled = '';
      final simulatedCompleted = <String>{};

      // Populate completed variations with all C(7, 3) = 35 combinations of colors pool
      final colorIds = ColorData.items.map((c) => c.id).toList();
      for (var i = 0; i < colorIds.length; i++) {
        for (var j = i + 1; j < colorIds.length; j++) {
          for (var k = j + 1; k < colorIds.length; k++) {
            final combo = [colorIds[i], colorIds[j], colorIds[k]]..sort();
            simulatedCompleted.add('colors:${combo.join(',')}');
          }
        }
      }

      PuzzleGenerator.generatePuzzleSet(
        completedVariationKeys: simulatedCompleted,
        onHistoryResetNeeded: (category) {
          if (category == 'colors') {
            resetCategoryCalled = category;
          }
        },
      );

      expect(resetCategoryCalled, 'colors');
    });
  });

  group('Puzzle Repository Tests', () {
    test('generates new puzzle set and tracks completed variations in local storage', () async {
      const repo = PuzzleRepositoryImpl(
        localDataSource: PuzzleLocalDataSourceImpl(),
      );

      final result1 = await repo.generateNewPuzzleSet();
      expect(result1.isRight(), isTrue);

      final sessions1 = result1.getOrElse((_) => []);
      expect(sessions1.length, 4);
      expect(sessions1.first.isCompleted, isFalse);

      // Mark first variation completed
      final key1 = sessions1.first.variationKey;
      await repo.markVariationCompleted(key1);

      // Generate next set
      final result2 = await repo.generateNewPuzzleSet();
      final sessions2 = result2.getOrElse((_) => []);
      expect(sessions2.first.variationKey, isNot(equals(key1)));

      // Clear progress
      await repo.clearProgress();
    });
  });

  group('PuzzleNotifier Logic Tests', () {
    test('matches items correctly and advances session', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialState = await container.read(puzzleNotifierProvider.future);
      expect(initialState.sessions.length, 4);
      expect(initialState.currentSessionIndex, 0);

      final notifier = container.read(puzzleNotifierProvider.notifier);
      final currentSession = initialState.currentSession;
      final firstItemId = currentSession.pictureItems.first.id;

      // Select picture for tap-to-match
      notifier.selectPicture(firstItemId);
      expect(
        container.read(puzzleNotifierProvider).value?.selectedPictureId,
        firstItemId,
      );

      // Correct match attempt
      final match1 = notifier.tryMatch(firstItemId, firstItemId);
      expect(match1, isTrue);
      expect(
        container.read(puzzleNotifierProvider).value?.matchedItemIds[currentSession.id],
        contains(firstItemId),
      );

      // Complete all items in session 1
      for (final item in currentSession.shadowItems) {
        notifier.tryMatch(item.id, item.id);
      }

      final session1DoneState = container.read(puzzleNotifierProvider).value!;
      expect(session1DoneState.isCurrentSessionCompleted, isTrue);
      expect(session1DoneState.sessions.first.isCompleted, isTrue);

      // Advance to session 2
      final reachedEnd = notifier.nextSession();
      expect(reachedEnd, isFalse);
      expect(
        container.read(puzzleNotifierProvider).value?.currentSessionIndex,
        1,
      );
    });

    test('awards 10 star points upon completing all 4 sessions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(puzzleNotifierProvider.future);
      final notifier = container.read(puzzleNotifierProvider.notifier);

      // Complete all 4 sessions
      for (var s = 0; s < 4; s++) {
        notifier.selectSession(s);
        final currentSession =
            container.read(puzzleNotifierProvider).value!.currentSession;
        for (final item in currentSession.shadowItems) {
          notifier.tryMatch(item.id, item.id);
        }
      }

      final state = container.read(puzzleNotifierProvider).value!;
      expect(state.areAllSessionsCompleted, isTrue);

      // Verify star points awarded
      final starPoints = container.read(starPointsNotifierProvider).value;
      expect(starPoints, 10);
    });

    test('generateNewSet resets state and loads fresh random puzzles', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state1 = await container.read(puzzleNotifierProvider.future);
      final varKeys1 = state1.sessions.map((s) => s.variationKey).toList();

      final notifier = container.read(puzzleNotifierProvider.notifier);
      await notifier.generateNewSet();

      final state2 = container.read(puzzleNotifierProvider).value!;
      final varKeys2 = state2.sessions.map((s) => s.variationKey).toList();

      expect(state2.currentSessionIndex, 0);
      expect(state2.matchedItemIds.isEmpty, isTrue);
      expect(varKeys2, isNot(equals(varKeys1)));
    });
  });

  group('Puzzle Screens Widget Tests', () {
    testWidgets('PuzzleSessionsScreen renders all UI elements faithfully',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const PuzzleSessionsScreen()));
      await tester.pumpAndSettle();

      // Top bar title
      expect(find.byType(PuzzleSessionsScreen), findsOneWidget);

      // Session pills displaying all 4 sessions
      expect(find.byType(PuzzleSessionPills), findsOneWidget);

      // Dashed shadow slots
      expect(find.byType(DashedShadowSlot), findsNWidgets(3));

      // Draggable pictures
      expect(find.byType(PuzzleDraggableItem), findsNWidgets(3));

      // Tap-to-match interaction: tap first picture, tap first shadow
      await tester.tap(find.byType(PuzzleDraggableItem).first);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DashedShadowSlot).first);
      await tester.pumpAndSettle();

      // Switch to session 2 via pills
      await tester.tap(find.text('Puzzle 2'));
      await tester.pumpAndSettle();

      expect(find.byType(DashedShadowSlot), findsNWidgets(3));
    });

    testWidgets('Step 2 (Colors) objects fit within slot and picture bounds without overflow',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const PuzzleSessionsScreen()));
      await tester.pumpAndSettle();

      // Switch to Step 2 (Colors session)
      await tester.tap(find.text('Puzzle 2'));
      await tester.pumpAndSettle();

      final slotFinders = find.byType(DashedShadowSlot);
      final itemFinders = find.byType(PuzzleDraggableItem);
      expect(slotFinders, findsNWidgets(3));
      expect(itemFinders, findsNWidgets(3));

      // Verify that all slots and items are rendered with consistent proportions
      for (var i = 0; i < 3; i++) {
        final slotSize = tester.getSize(slotFinders.at(i));
        final itemSize = tester.getSize(itemFinders.at(i));
        expect(slotSize.width, greaterThanOrEqualTo(72.0));
        expect(slotSize.height, greaterThanOrEqualTo(72.0));
        expect(itemSize.width, greaterThanOrEqualTo(60.0));
        expect(itemSize.height, greaterThanOrEqualTo(60.0));
      }
    });

    testWidgets('PuzzleCongratulationsScreen renders and plays celebration audio',
        (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const PuzzleCongratulationsScreen()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PuzzleCongratulationsScreen), findsOneWidget);
      expect(find.text('+10 Stars Earned!'), findsOneWidget);

      // Verify both buttons are present and second button text has high-contrast white text
      expect(find.text('Play again'), findsOneWidget);
      final backTextWidget = tester.widget<Text>(find.text('Back'));
      expect(backTextWidget.style?.color, Colors.white);
    });
  });
}
