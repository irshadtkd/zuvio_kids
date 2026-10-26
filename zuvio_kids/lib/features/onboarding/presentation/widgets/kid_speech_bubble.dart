import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'animal_avatar.dart';

/// Kid-friendly speech bubble with the character avatar.
class KidSpeechBubble extends StatelessWidget {
  const KidSpeechBubble({
    super.key,
    required this.message,
    this.avatar = AppStrings.idFriendPanda,
  });

  final String message;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimalAvatar(
          avatarType: avatar,
          size: 56,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.speechBubbleBg,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              message,
              style: AppTextStyles.speechBubbleBody.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Large centered speech bubble used on the Welcome Screen.
class KidWelcomeSpeechBubble extends StatelessWidget {
  const KidWelcomeSpeechBubble({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.speechBubbleBg,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.speechBubbleTitle.copyWith(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.speechBubbleBody.copyWith(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
