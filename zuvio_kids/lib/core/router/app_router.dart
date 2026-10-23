import 'package:flutter/material.dart';


/// Centralised route generator for ZuvioKids.
/// Register every new named route here.
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Feature routes are registered here as they are implemented.
      // Example:
      // case AppRoutes.home:
      //   return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }
}

/// Shown when a route is not found. Replace with a proper 404 widget.
class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('404 — Page not found')),
    );
  }
}
