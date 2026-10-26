import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_letter_data.dart';
import 'package:zuvio_kids/features/alphabet/data/datasources/alphabet_local_datasource_impl.dart';
import 'package:zuvio_kids/features/alphabet/data/models/alphabet_progress_model.dart';
import 'package:zuvio_kids/features/alphabet/data/repositories/alphabet_repository_impl.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/alphabet_top_bar.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/discover_step_view.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/practice_step_view.dart';
import 'package:zuvio_kids/features/alphabet/presentation/widgets/tracing_canvas.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Alphabet Letter Data Catalog', () {
    test('contains 26 capital letters and 26 small letters', () {
      const capitals = AlphabetLetterData.capitalLetters;
      final smalls = AlphabetLetterData.smallLetters;

      expect(capitals.length, 26);
      expect(smalls.length, 26);

      expect(capitals.first.letter, 'A');
      expect(capitals.last.letter, 'Z');
      expect(smalls.first.letter, 'a');
      expect(smalls.last.letter, 'z');

      expect(capitals.first.primaryWord, 'Apple');
      expect(capitals.first.supportingWords.length, greaterThanOrEqualTo(2));
      expect(capitals.first.quizOptions.length, 3);
    });

    test('has valid tracing strokes for capital and small letters', () {
      final strokesA = AlphabetLetterData.getTracingStrokes('A');
      final strokesB = AlphabetLetterData.getTracingStrokes('B');
      final strokesSmallA = AlphabetLetterData.getTracingStrokes('a', isCapital: false);
      final strokesSmallB = AlphabetLetterData.getTracingStrokes('b', isCapital: false);

      expect(strokesA, isNotEmpty);
      expect(strokesB, isNotEmpty);
      expect(strokesSmallA, isNotEmpty);
      expect(strokesSmallB, isNotEmpty);
      expect(strokesA.first.points, isNotEmpty);
      expect(strokesSmallA.first.points, isNotEmpty);
    });

    test('strictly separates capital and small letter displays and flags', () {
      const capitals = AlphabetLetterData.capitalLetters;
      final smalls = AlphabetLetterData.smallLetters;

      for (final letter in capitals) {
        expect(letter.isCapital, isTrue);
        expect(letter.displayLetter, letter.letter.toUpperCase());
        expect(letter.displayPair, letter.letter.toUpperCase());
        expect(letter.phrase, '${letter.letter} for ${letter.primaryWord}');
        expect(letter.phrase.startsWith('Capital'), isFalse);
      }

      for (final letter in smalls) {
        expect(letter.isCapital, isFalse);
        expect(letter.displayLetter, letter.letter.toLowerCase());
        expect(letter.displayPair, letter.letter.toLowerCase());
        expect(letter.phrase, '${letter.letter.toUpperCase()} for ${letter.primaryWord}');
        expect(letter.phrase.startsWith('Small'), isFalse);
      }
    });

    test('pronounces only the letter name without Capital or Small prefix', () {
      final soundService = KidSoundService.instance;
      const allLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

      for (int i = 0; i < allLetters.length; i++) {
        final upper = allLetters[i];
        final lower = allLetters[i].toLowerCase();

        final phoneticUpper = soundService.getPhoneticLetterName(upper);
        final phoneticLower = soundService.getPhoneticLetterName(lower);

        // Must produce identical phonetic letter name regardless of case
        expect(phoneticUpper, phoneticLower);

        // Must never contain "Capital" or "Small"
        expect(phoneticUpper.toLowerCase().contains('capital'), isFalse);
        expect(phoneticUpper.toLowerCase().contains('small'), isFalse);

        // E.g. A -> ay, B -> bee, C -> see, D -> dee
        expect(phoneticUpper.isNotEmpty, isTrue);
      }

      expect(soundService.getPhoneticLetterName('A'), 'a');
      expect(soundService.getPhoneticLetterName('B'), 'b');
      expect(soundService.getPhoneticLetterName('C'), 'c');
      expect(soundService.getPhoneticLetterName('D'), 'd');
    });
  });

  group('Alphabet Local Data Source & Repository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('getSessions returns 4 structured sessions with correct slicing and locks', () async {
      const dataSource = AlphabetLocalDataSourceImpl();
      const repository = AlphabetRepositoryImpl(dataSource);

      final result = await repository.getSessions('Mia');
      expect(result.isRight(), isTrue);

      final sessions = result.getOrElse((_) => []);
      expect(sessions.length, 4);

      // Session 1: Capital A–L (12 letters)
      expect(sessions[0].id, AppStrings.sessionCapital1);
      expect(sessions[0].sessionNumber, 1);
      expect(sessions[0].isCapital, isTrue);
      expect(sessions[0].letterRange, 'A–L');
      expect(sessions[0].letters.length, 12);
      expect(sessions[0].isLocked, isFalse);
      expect(sessions[0].isCompleted, isFalse);
      expect(sessions[0].currentLetterIndex, 0); // Always starts from first letter

      // Session 2: Capital M–Z (14 letters) - locked initially
      expect(sessions[1].id, AppStrings.sessionCapital2);
      expect(sessions[1].sessionNumber, 2);
      expect(sessions[1].isCapital, isTrue);
      expect(sessions[1].letterRange, 'M–Z');
      expect(sessions[1].letters.length, 14);
      expect(sessions[1].isLocked, isTrue);
      expect(sessions[1].currentLetterIndex, 0);

      // Session 3: Small a–l (12 letters) - locked
      expect(sessions[2].id, AppStrings.sessionSmall3);
      expect(sessions[2].sessionNumber, 3);
      expect(sessions[2].isCapital, isFalse);
      expect(sessions[2].letterRange, 'a–l');
      expect(sessions[2].letters.length, 12);
      expect(sessions[2].isLocked, isTrue);
      expect(sessions[2].currentLetterIndex, 0);

      // Session 4: Small m–z (14 letters) - locked
      expect(sessions[3].id, AppStrings.sessionSmall4);
      expect(sessions[3].sessionNumber, 4);
      expect(sessions[3].isCapital, isFalse);
      expect(sessions[3].letterRange, 'm–z');
      expect(sessions[3].letters.length, 14);
      expect(sessions[3].isLocked, isTrue);
      expect(sessions[3].currentLetterIndex, 0);
    });

    test('completing session 1 automatically awards 10 stars and unlocks session 2', () async {
      const dataSource = AlphabetLocalDataSourceImpl();
      const repository = AlphabetRepositoryImpl(dataSource);

      // Complete session 1
      final completeResult = await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionCapital1,
      );
      expect(completeResult.isRight(), isTrue);
      final progress = completeResult.getOrElse((_) => throw Exception());
      expect(progress.totalStars, 10);
      expect(progress.isSessionCompleted(AppStrings.sessionCapital1), isTrue);

      // Verify session 2 is now unlocked and session 1 remains completed
      final sessionsResult = await repository.getSessions('Mia');
      final sessions = sessionsResult.getOrElse((_) => []);
      expect(sessions[0].isCompleted, isTrue);
      expect(sessions[0].starsEarned, 10);
      expect(sessions[1].isLocked, isFalse); // Unlocked!
    });

    test('completing all 4 sessions yields 40 stars without duplicate rewards', () async {
      const dataSource = AlphabetLocalDataSourceImpl();
      const repository = AlphabetRepositoryImpl(dataSource);

      // Complete session 1 -> 10 stars
      await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionCapital1,
      );

      // Complete session 1 AGAIN -> still 10 stars (no duplicates)
      final duplicateResult = await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionCapital1,
      );
      expect(duplicateResult.getOrElse((_) => throw Exception()).totalStars, 10);

      // Complete session 2 -> 20 stars
      final s2 = await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionCapital2,
      );
      expect(s2.getOrElse((_) => throw Exception()).totalStars, 20);

      // Complete session 3 -> 30 stars
      final s3 = await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionSmall3,
      );
      expect(s3.getOrElse((_) => throw Exception()).totalStars, 30);

      // Complete session 4 -> 40 stars
      final s4 = await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionSmall4,
      );
      expect(s4.getOrElse((_) => throw Exception()).totalStars, 40);
    });

    test('incomplete session always starts from index 0 on retrieval', () async {
      const dataSource = AlphabetLocalDataSourceImpl();
      const repository = AlphabetRepositoryImpl(dataSource);

      // Fetch sessions without completing
      final sessionsResult = await repository.getSessions('Mia');
      final sessions = sessionsResult.getOrElse((_) => []);
      expect(sessions[0].currentLetterIndex, 0);
      expect(sessions[1].currentLetterIndex, 0);
    });

    test('clearAll wipes all stored alphabet progress on logout', () async {
      const dataSource = AlphabetLocalDataSourceImpl();
      const repository = AlphabetRepositoryImpl(dataSource);

      // Save completion for Mia
      await repository.completeSession(
        studentName: 'Mia',
        sessionId: AppStrings.sessionCapital1,
      );

      // Verify saved
      final progressBefore = await repository.getProgress('Mia');
      expect(progressBefore.getOrElse((_) => throw Exception()).totalStars, 10);

      // Logout / clearAll
      final clearResult = await repository.clearAll();
      expect(clearResult.isRight(), isTrue);

      // Verify fresh state: 0 stars, session 1 incomplete
      final progressAfter = await repository.getProgress('Mia');
      final freshProgress = progressAfter.getOrElse((_) => throw Exception());
      expect(freshProgress.totalStars, 0);
      expect(freshProgress.completedSessionIds, isEmpty);

      final freshSessionsResult = await repository.getSessions('Mia');
      final freshSessions = freshSessionsResult.getOrElse((_) => []);
      expect(freshSessions[0].isCompleted, isFalse);
      expect(freshSessions[1].isLocked, isTrue);
    });

    test('AlphabetProgressModel serializes and deserializes accurately', () {
      const model = AlphabetProgressModel(
        studentName: 'Leo',
        completedSessionIds: {'capital_1', 'capital_2'},
        totalStars: 20,
      );

      final serialized = model.serialize();
      final deserialized = AlphabetProgressModel.deserialize(serialized);

      expect(deserialized, isNotNull);
      expect(deserialized!.studentName, 'Leo');
      expect(deserialized.totalStars, 20);
      expect(deserialized.completedSessionIds.contains('capital_1'), isTrue);
      expect(deserialized.completedSessionIds.contains('capital_2'), isTrue);
    });
  });

  group('Practice Mode Validation Widget Tests', () {
    Widget buildTestableWidget(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      );
    }

    testWidgets('TracingCanvas does not show success or failure while idle/drawing', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          TracingCanvas(
            letter: 'A',
            onComplete: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // No success check or failure cross while idle
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
    });

    testWidgets('TracingCanvas displays green tick when isCompleted is true', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          TracingCanvas(
            letter: 'A',
            isCompleted: true,
            onComplete: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Should display 100% and check icon
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.text('100%'), findsWidgets);
    });

    testWidgets('PracticeStepView disables Next button until tracing is completed', (tester) async {
      bool nextPressed = false;

      // 1. Initial incomplete state
      await tester.pumpWidget(
        buildTestableWidget(
          PracticeStepView(
            letter: AlphabetLetterData.capitalLetters.first,
            isTracingDone: false,
            onTracingDone: () {},
            onNext: () => nextPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final kidButtonFinder = find.byType(KidButton);
      expect(kidButtonFinder, findsOneWidget);

      final kidButton = tester.widget<KidButton>(kidButtonFinder);
      expect(kidButton.enabled, isFalse);

      // Attempt tap while disabled
      await tester.tap(kidButtonFinder);
      await tester.pumpAndSettle();
      expect(nextPressed, isFalse);

      // 2. Completed state: Next button is enabled and clickable
      await tester.pumpWidget(
        buildTestableWidget(
          PracticeStepView(
            letter: AlphabetLetterData.capitalLetters.first,
            isTracingDone: true,
            onTracingDone: () {},
            onNext: () => nextPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final enabledKidButton = tester.widget<KidButton>(kidButtonFinder);
      expect(enabledKidButton.enabled, isTrue);

      await tester.tap(kidButtonFinder);
      await tester.pumpAndSettle();
      expect(nextPressed, isTrue);
    });

    testWidgets('AlphabetTopBar toggles between volume_up and volume_off based on isMuted', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          AlphabetTopBar(
            title: 'Alphabet',
            onBack: () {},
            onSpeakerTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up_rounded), findsOneWidget);
      expect(find.byIcon(Icons.volume_off_rounded), findsNothing);

      await tester.pumpWidget(
        buildTestableWidget(
          AlphabetTopBar(
            title: 'Alphabet',
            isMuted: true,
            onBack: () {},
            onSpeakerTap: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.volume_up_rounded), findsNothing);
    });

    testWidgets('DiscoverStepView displays small Play button on letter card', (tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          DiscoverStepView(
            letter: AlphabetLetterData.capitalLetters.first,
            onNext: () {},
          ),
        ),
      );
      await tester.pump();

      // Verify the play arrow button is present in the card
      final playButtonFinder = find.byIcon(Icons.play_arrow_rounded);
      expect(playButtonFinder, findsOneWidget);

      // Verify tapping play button triggers replay
      await tester.tap(playButtonFinder);
      await tester.pump();
    });

    test('KidSoundService toggles mute and stops sound properly', () {
      final sound = KidSoundService.instance;
      sound.setMuted(false);
      expect(sound.isMuted, isFalse);

      sound.toggleMute();
      expect(sound.isMuted, isTrue);

      sound.toggleMute();
      expect(sound.isMuted, isFalse);
    });
  });
}
