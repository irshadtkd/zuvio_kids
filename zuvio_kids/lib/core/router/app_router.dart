import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_congratulations_screen.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_hub_screen.dart';
import 'package:zuvio_kids/features/alphabet/presentation/screens/alphabet_learning_screen.dart';
import 'package:zuvio_kids/features/home/presentation/screens/home_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:zuvio_kids/features/onboarding/presentation/screens/welcome_screen.dart';

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
