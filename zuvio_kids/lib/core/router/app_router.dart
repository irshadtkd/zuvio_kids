import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/features/achievements/presentation/screens/trophy_room_screen.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_congratulations_screen.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_hub_screen.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_learning_screen.dart';
import 'package:zuvio_kids/features/animals/presentation/screens/animals_congratulations_screen.dart';
import 'package:zuvio_kids/features/animals/presentation/screens/animals_hub_screen.dart';
import 'package:zuvio_kids/features/animals/presentation/screens/animals_learning_screen.dart';
import 'package:zuvio_kids/features/animals/presentation/screens/animals_quiz_screen.dart';
import 'package:zuvio_kids/features/colors/presentation/screens/colors_congratulations_screen.dart';
import 'package:zuvio_kids/features/colors/presentation/screens/colors_learning_screen.dart';
import 'package:zuvio_kids/features/home/presentation/screens/home_screen.dart';
import 'package:zuvio_kids/features/numbers/presentation/screens/numbers_congratulations_screen.dart';
import 'package:zuvio_kids/features/numbers/presentation/screens/numbers_hub_screen.dart';
import 'package:zuvio_kids/features/numbers/presentation/screens/numbers_learning_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:zuvio_kids/features/puzzle/presentation/screens/puzzle_congratulations_screen.dart';
import 'package:zuvio_kids/features/puzzle/presentation/screens/puzzle_sessions_screen.dart';
import 'package:zuvio_kids/features/shapes/presentation/screens/shapes_congratulations_screen.dart';
import 'package:zuvio_kids/features/shapes/presentation/screens/shapes_hub_screen.dart';
import 'package:zuvio_kids/features/shapes/presentation/screens/shapes_learning_screen.dart';

/// Centralised route generator for ZuvioKids.
/// Register every new named route here.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      case AppRoutes.alphabetHub:
        return MaterialPageRoute(
          builder: (_) => const AlphabetHubScreen(),
          settings: settings,
        );
      case AppRoutes.alphabetLearning:
        return MaterialPageRoute(
          builder: (_) => const AlphabetLearningScreen(),
          settings: settings,
        );
      case AppRoutes.alphabetCongrats:
        return MaterialPageRoute(
          builder: (_) => const AlphabetCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.numbersHub:
        return MaterialPageRoute(
          builder: (_) => const NumbersHubScreen(),
          settings: settings,
        );
      case AppRoutes.numbersLearning:
        return MaterialPageRoute(
          builder: (_) => const NumbersLearningScreen(),
          settings: settings,
        );
      case AppRoutes.numbersCongrats:
        return MaterialPageRoute(
          builder: (_) => const NumbersCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.colorsLearning:
        return MaterialPageRoute(
          builder: (_) => const ColorsLearningScreen(),
          settings: settings,
        );
      case AppRoutes.colorsCongrats:
        return MaterialPageRoute(
          builder: (_) => const ColorsCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.shapesHub:
        return MaterialPageRoute(
          builder: (_) => const ShapesHubScreen(),
          settings: settings,
        );
      case AppRoutes.shapesLearning:
        return MaterialPageRoute(
          builder: (_) => const ShapesLearningScreen(),
          settings: settings,
        );
      case AppRoutes.shapesCongrats:
        return MaterialPageRoute(
          builder: (_) => const ShapesCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.puzzleSessions:
        return MaterialPageRoute(
          builder: (_) => const PuzzleSessionsScreen(),
          settings: settings,
        );
      case AppRoutes.puzzleCongrats:
        return MaterialPageRoute(
          builder: (_) => const PuzzleCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.animalsHub:
        return MaterialPageRoute(
          builder: (_) => const AnimalsHubScreen(),
          settings: settings,
        );
      case AppRoutes.animalsLearning:
        return MaterialPageRoute(
          builder: (_) => const AnimalsLearningScreen(),
          settings: settings,
        );
      case AppRoutes.animalsCongrats:
        return MaterialPageRoute(
          builder: (_) => const AnimalsCongratulationsScreen(),
          settings: settings,
        );
      case AppRoutes.animalsQuiz:
        return MaterialPageRoute(
          builder: (ctx) => AnimalsQuizScreen(
            onQuizComplete: () => Navigator.pop(ctx),
          ),
          settings: settings,
        );
      case AppRoutes.trophyRoom:
        return MaterialPageRoute(
          builder: (_) => const TrophyRoomScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// Shown when a route is not found.
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Text(l10n?.errorPageNotFound ?? '404'),
      ),
    );
  }
}
