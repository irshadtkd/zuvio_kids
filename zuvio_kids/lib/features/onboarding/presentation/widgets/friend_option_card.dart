import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'animal_avatar.dart';

/// Card in the 2x3 grid for choosing a cartoon learning friend.
class FriendOptionCard extends StatelessWidget {
  const FriendOptionCard({
    super.key,
    required this.name,
    required this.avatarType,
    required this.backgroundColor,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final String avatarType;
  final Color backgroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? Border.all(color: AppColors.navy, width: 3.2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimalAvatar(
              avatarType: avatarType,
              size: 68,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTextStyles.friendName.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
