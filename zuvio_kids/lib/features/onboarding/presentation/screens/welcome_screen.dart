import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
//import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import '../widgets/animal_avatar.dart';
import '../widgets/kid_button.dart';
import '../widgets/kid_speech_bubble.dart';

/// Welcome / Start screen welcoming the child with Panda friend.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // void _onForParents(BuildContext context) {
  //   final l10n = AppLocalizations.of(context)!;
  //   showDialog<void>(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       backgroundColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(24),
  //       ),
  //       title: Text(
  //         l10n.titleParentsSection,
  //         style: AppTextStyles.headerTitle.copyWith(fontSize: 22),
  //       ),
  //       content: Text(
  //         l10n.msgParentsSection,
  //         style: AppTextStyles.speechBubbleBody.copyWith(fontSize: 16),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(ctx),
  //           child: Text(
  //             l10n.btnClose,
  //             style: AppTextStyles.buttonLabel.copyWith(
  //               fontSize: 18,
  //               color: AppColors.kidGreen,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
              const Spacer(flex: 3),
              // Panda Mascot
              const AnimalAvatar(
                avatarType: AppStrings.idFriendPanda,
                size: 210,
              ),
              const SizedBox(height: 36),
              // Welcome Speech Bubble
              KidWelcomeSpeechBubble(
                title: l10n.headingWelcomeFriend,
                message: l10n.msgWelcomePanda,
              ),
              const Spacer(flex: 4),
              // Start Button
              KidButton(
                label: l10n.btnStart,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.onboarding);
                },
              ),
              const SizedBox(height: 24),
              // For Parents Link
              // GestureDetector(
              //   onTap: () => _onForParents(context),
              //   child: Text(
              //     l10n.btnForParents,
              //     style: AppTextStyles.footerLink,
              //   ),
              // ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
