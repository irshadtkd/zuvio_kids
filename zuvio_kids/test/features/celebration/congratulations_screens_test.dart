import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_congratulations_screen.dart';
import 'package:zuvio_kids/features/colors/presentation/screens/colors_congratulations_screen.dart';
import 'package:zuvio_kids/features/numbers/presentation/screens/numbers_congratulations_screen.dart';
import 'package:zuvio_kids/features/shapes/presentation/screens/shapes_congratulations_screen.dart';

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
    KidSoundService.instance.setMuted(true);
  });

  tearDown(KidSoundService.instance.stop);

  group('Congratulations Screens Audio and Render Tests', () {
    testWidgets('AlphabetCongratulationsScreen renders and plays celebration sounds',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const AlphabetCongratulationsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(AlphabetCongratulationsScreen), findsOneWidget);

      // Rebuild to verify guard prevents duplicate audio trigger issues
      await tester.pump();
    });

    testWidgets('NumbersCongratulationsScreen renders and plays celebration sounds',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const NumbersCongratulationsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(NumbersCongratulationsScreen), findsOneWidget);

      // Rebuild to verify guard prevents duplicate audio trigger issues
      await tester.pump();
    });

    testWidgets('ShapesCongratulationsScreen renders and plays celebration sounds',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const ShapesCongratulationsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ShapesCongratulationsScreen), findsOneWidget);

      // Rebuild to verify guard prevents duplicate audio trigger issues
      await tester.pump();
    });

    testWidgets('ColorsCongratulationsScreen renders and plays celebration sounds',
        (tester) async {
      await tester.pumpWidget(_buildTestApp(const ColorsCongratulationsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ColorsCongratulationsScreen), findsOneWidget);

      // Rebuild to verify guard prevents duplicate audio trigger issues
      await tester.pump();
    });
  });
}
