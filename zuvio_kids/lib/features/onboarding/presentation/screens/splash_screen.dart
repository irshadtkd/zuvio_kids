import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import '../widgets/animal_avatar.dart';

/// Splash screen displaying branding, cute Panda mascot, and progress animation.
/// Automatically routes returning users directly to Home, or new users to Welcome.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOutCubic,
      ),
    );

    _startFlow();
  }

  Future<void> _startFlow() async {
    // Start progress bar animation
    _progressController.forward();

    // Check user profile from local storage
    final getUserProfile = ref.read(getUserProfileUseCaseProvider);
    final result = await getUserProfile();

    // Wait until progress animation completes
    await Future<void>.delayed(const Duration(milliseconds: 1900));

    if (!mounted) return;

    final isCompleted = result.fold(
      (failure) => false,
      (profile) => profile?.isOnboardingCompleted ?? false,
    );

    if (isCompleted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appSkyBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Panda Mascot
              const AnimalAvatar(
                avatarType: AppStrings.idFriendPanda,
                size: 190,
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                l10n.titleSplashAdventure,
                textAlign: TextAlign.center,
                style: AppTextStyles.splashTitle,
              ),
              const SizedBox(height: 12),
              // Subtitle
              Text(
                l10n.subtitleSplash,
                textAlign: TextAlign.center,
                style: AppTextStyles.splashSubtitle,
              ),
              const SizedBox(height: 28),
              // Progress Bar (Pill)
              Container(
                width: 150,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.centerLeft,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return FractionallySizedBox(
                      widthFactor: _progressAnimation.value.clamp(0.0, 1.0),
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.progressYellow,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(flex: 3),
              // Footer Caption
              Text(
                l10n.captionSplash,
                style: AppTextStyles.splashCaption,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
