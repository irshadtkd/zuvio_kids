import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_data.dart';
import 'package:zuvio_kids/features/colors/data/datasources/color_local_datasource.dart';
import 'package:zuvio_kids/features/colors/data/models/color_progress_model.dart';
import 'package:zuvio_kids/features/colors/data/repositories/color_repository_impl.dart';
import 'package:zuvio_kids/features/colors/presentation/providers/colors_provider.dart';

import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_notifier.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_state.dart';

class _MockColorLocalDataSource implements ColorLocalDataSource {
  ColorProgressModel? progress;

  @override
  Future<ColorProgressModel?> getProgress(String studentName) async {
    return progress;
  }

  @override
  Future<void> saveProgress(ColorProgressModel model) async {
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

class _MockOnboardingNotifier extends OnboardingNotifier {
  @override
  Future<OnboardingState> build() async => const OnboardingState(name: 'Mia');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    KidSoundService.instance.setMuted(true);
  });

  group('Colors Data Catalog Tests', () {
    test('contains exactly 7 colors with valid properties', () {
      const items = ColorData.items;
      expect(items.length, 7);

      const expectedIds = [
        'red',
        'yellow',
        'green',
        'blue',
        'orange',
        'purple',
        'pink',
      ];

      expect(items.map((c) => c.id).toList(), expectedIds);

      for (final item in items) {
        expect(item.name.isNotEmpty, isTrue);
        expect(item.objectName.isNotEmpty, isTrue);
        expect(item.paletteOptions.length, 5);
        expect(item.paletteOptions.contains(item.colorValue), isTrue);
      }
    });

    test('default session contains all 7 colors', () {
      const session = ColorData.defaultSession;
      expect(session.colors.length, 7);
      expect(session.isCompleted, isFalse);
    });
  });

  group('ColorsNotifier Session Flow Tests', () {
    late ProviderContainer container;
    late _MockColorLocalDataSource mockLocalDataSource;

    setUp(() {
      mockLocalDataSource = _MockColorLocalDataSource();
      final repository = ColorRepositoryImpl(mockLocalDataSource);

      container = ProviderContainer(
        overrides: [
          colorRepositoryProvider.overrideWithValue(repository),
          onboardingNotifierProvider.overrideWith(_MockOnboardingNotifier.new),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
        'Step 0: advances through all 7 colors and transitions to Step 1 at index 0',
        () async {
      final notifier = container.read(colorsNotifierProvider.notifier);

      // Wait for initial load
      var state = await container.read(colorsNotifierProvider.future);
      expect(state.currentStep, 0);
      expect(state.currentColorIndex, 0);
      expect(state.currentColor.id, 'red');

      // Advance through colors 1 to 6 in Step 0
      final expectedColorIds = [
        'yellow',
        'green',
        'blue',
        'orange',
        'purple',
        'pink',
      ];

      for (int i = 0; i < expectedColorIds.length; i++) {
        await notifier.nextStep();
        state = container.read(colorsNotifierProvider).requireValue;
        expect(state.currentStep, 0);
        expect(state.currentColorIndex, i + 1);
        expect(state.currentColor.id, expectedColorIds[i]);
      }

      // At color index 6 (pink) in Step 0, advancing transitions to Step 1 at index 0
      await notifier.nextStep();
      state = container.read(colorsNotifierProvider).requireValue;
      expect(state.currentStep, 1);
      expect(state.currentColorIndex, 0);
      expect(state.currentColor.id, 'red');
    });

    test(
        'Step 1: validates color selection and advances through all 7 objects to complete session',
        () async {
      final notifier = container.read(colorsNotifierProvider.notifier);
      await container.read(colorsNotifierProvider.future);

      // Set to Step 1 directly
      notifier.setStep(1);
      var state = container.read(colorsNotifierProvider).requireValue;
      expect(state.currentStep, 1);
      expect(state.currentColorIndex, 0);

      // Wrong color check
      notifier.selectPaletteColor(ColorData.hexBlue);
      state = container.read(colorsNotifierProvider).requireValue;
      expect(state.isPaintCorrect, isFalse);
      expect(state.appliedColorValue, ColorData.hexBlue);

      // Correct color for Red (Apple)
      notifier.selectPaletteColor(ColorData.hexRed);
      state = container.read(colorsNotifierProvider).requireValue;
      expect(state.isPaintCorrect, isTrue);
      expect(state.appliedColorValue, ColorData.hexRed);

      // Advance through the remaining 6 objects
      for (int i = 1; i <= 6; i++) {
        await notifier.nextStep();
        state = container.read(colorsNotifierProvider).requireValue;
        expect(state.currentStep, 1);
        expect(state.currentColorIndex, i);
        expect(state.isPaintCorrect, isNull);
        expect(state.appliedColorValue, isNull);

        // Apply correct color
        notifier.selectPaletteColor(state.currentColor.colorValue);
        state = container.read(colorsNotifierProvider).requireValue;
        expect(state.isPaintCorrect, isTrue);
      }

      // At 7th object (pink flower, index 6), advancing completes the session
      await notifier.nextStep();
      state = container.read(colorsNotifierProvider).requireValue;
      expect(state.isSessionCompleted, isTrue);

      // Verify star points were awarded (+10)
      final starPoints = container.read(starPointsNotifierProvider).requireValue;
      expect(starPoints, 10);
    });

    test('playAgain resets state to step 0, color 0', () async {
      final notifier = container.read(colorsNotifierProvider.notifier);
      await container.read(colorsNotifierProvider.future);

      notifier.setStep(1);
      await notifier.completeCurrentSession();

      var state = container.read(colorsNotifierProvider).requireValue;
      expect(state.isSessionCompleted, isTrue);

      notifier.playAgain();
      state = container.read(colorsNotifierProvider).requireValue;
      expect(state.currentStep, 0);
      expect(state.currentColorIndex, 0);
      expect(state.isSessionCompleted, isFalse);
    });
  });
}
