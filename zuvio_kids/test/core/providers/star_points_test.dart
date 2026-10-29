import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/providers/star_points_provider.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StarPointsNotifier Tests', () {
    test('initializes with 0 star points when no saved points exist', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialPoints = await container.read(starPointsNotifierProvider.future);
      expect(initialPoints, 0);
    });

    test('awards 10 star points and saves to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(starPointsNotifierProvider.future);
      await container.read(starPointsNotifierProvider.notifier).awardPoints();

      final pointsAfterAward = container.read(starPointsNotifierProvider).value;
      expect(pointsAfterAward, 10);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(AppStrings.prefTotalStarPoints), 10);
    });

    test('accumulates star points across multiple session completions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(starPointsNotifierProvider.future);
      await container.read(starPointsNotifierProvider.notifier).awardPoints();
      await container.read(starPointsNotifierProvider.notifier).awardPoints();
      await container.read(starPointsNotifierProvider.notifier).awardPoints();

      expect(container.read(starPointsNotifierProvider).value, 30);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt(AppStrings.prefTotalStarPoints), 30);
    });

    test('retains star points across app restarts', () async {
      SharedPreferences.setMockInitialValues({
        AppStrings.prefTotalStarPoints: 50,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final loadedPoints = await container.read(starPointsNotifierProvider.future);
      expect(loadedPoints, 50);
    });

    test('clears stored star points on clearPoints (logout)', () async {
      SharedPreferences.setMockInitialValues({
        AppStrings.prefTotalStarPoints: 40,
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(starPointsNotifierProvider.future);
      await container.read(starPointsNotifierProvider.notifier).clearPoints();

      expect(container.read(starPointsNotifierProvider).value, 0);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(AppStrings.prefTotalStarPoints), isFalse);
    });
  });
}
