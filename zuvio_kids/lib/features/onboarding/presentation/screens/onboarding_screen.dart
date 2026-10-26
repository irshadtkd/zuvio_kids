import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_routes.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/features/onboarding/presentation/providers/onboarding_provider.dart';
import '../widgets/class_option_card.dart';
import '../widgets/friend_option_card.dart';
import '../widgets/kid_button.dart';
import '../widgets/kid_keyboard.dart';
import '../widgets/kid_speech_bubble.dart';
import '../widgets/kid_step_header.dart';

/// 3-step interactive onboarding flow (Name, Class, Cartoon Friend).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final initialName =
        ref.read(onboardingNotifierProvider).valueOrNull?.name ??
        AppStrings.defaultChildName;
    _nameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onKeyTapped(String char) {
    final current = _nameController.text;
    // Block input once max length is reached
    if (current.length >= AppSizes.nameMaxLength) return;
    setState(() {
      _nameController.text = current + char;
      _nameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nameController.text.length),
      );
    });
    ref.read(onboardingNotifierProvider.notifier).setName(_nameController.text);
  }

  void _onBackspace() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _nameController.text = _nameController.text.substring(
          0,
          _nameController.text.length - 1,
        );
        _nameController.selection = TextSelection.fromPosition(
          TextPosition(offset: _nameController.text.length),
        );
      });
      ref
          .read(onboardingNotifierProvider.notifier)
          .setName(_nameController.text);
    }
  }

  Future<void> _onFinishOnboarding() async {
    final notifier = ref.read(onboardingNotifierProvider.notifier);
    final success = await notifier.completeOnboarding();
    if (!mounted) return;

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(onboardingNotifierProvider).valueOrNull;
    final currentStep = state?.currentStep ?? 0;
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.appSkyBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            children: [
              // ── Top Header with Back button and 3 Step Pills ──────
              KidStepHeader(
                title: switch (currentStep) {
                  0 => l10n.titleYourName,
                  1 => l10n.titleMyClass,
                  _ => l10n.titleMyFriend,
                },
                currentStep: currentStep,
                onBack: () {
                  if (currentStep > 0) {
                    notifier.previousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 18),

              // ── Speech Bubble with Panda ──────────────────────────
              KidSpeechBubble(
                message: switch (currentStep) {
                  0 => l10n.speechBubbleName,
                  1 => l10n.speechBubbleClass,
                  _ => l10n.speechBubbleFriend,
                },
              ),
              const SizedBox(height: 18),

              // ── Step Content ──────────────────────────────────────
              Expanded(
                child: switch (currentStep) {
                  0 => _buildNameStep(l10n),
                  1 => _buildClassStep(
                    l10n,
                    state?.studentClass ?? AppStrings.defaultClass,
                    notifier,
                  ),
                  _ => _buildFriendStep(
                    l10n,
                    state?.friendAvatar ?? AppStrings.defaultFriend,
                    notifier,
                  ),
                },
              ),

              // ── Bottom Action Button ──────────────────────────────
              Builder(
                builder: (context) {
                  final currentName =
                      ref.watch(onboardingNotifierProvider).valueOrNull?.name ??
                      '';
                  final nameValid =
                      currentName.trim().length >= AppSizes.nameMinLength;
                  final canProceed = currentStep != 0 || nameValid;

                  return KidButton(
                    label: currentStep == 2 ? l10n.btnDone : l10n.btnNext,
                    onPressed: canProceed
                        ? () {
                            if (currentStep < 2) {
                              notifier.nextStep();
                            } else {
                              _onFinishOnboarding();
                            }
                          }
                        : null,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step 0: Name Input & Kid Keyboard ─────────────────────────────────
  Widget _buildNameStep(AppLocalizations l10n) {
    final currentName = _nameController.text;
    final isTooShort =
        currentName.isNotEmpty &&
        currentName.trim().length < AppSizes.nameMinLength;
    final atMax = currentName.length >= AppSizes.nameMaxLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.labelName, style: AppTextStyles.inputLabel),
            // Character counter badge
            Text(
              '${currentName.length}/${AppSizes.nameMaxLength}',
              style: AppTextStyles.inputLabel.copyWith(
                color: atMax ? AppColors.error : AppColors.textHint,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isTooShort ? AppColors.error : AppColors.navy,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: _nameController,
            style: AppTextStyles.inputValue,
            decoration: InputDecoration(
              isDense: true,
              hintText: l10n.hintChildName,
              hintStyle: AppTextStyles.inputValue.copyWith(
                color: AppColors.textHint,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (val) {
              // Enforce max length on system keyboard too
              if (val.length > AppSizes.nameMaxLength) {
                _nameController.text = val.substring(0, AppSizes.nameMaxLength);
                _nameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _nameController.text.length),
                );
                ref
                    .read(onboardingNotifierProvider.notifier)
                    .setName(_nameController.text);
              } else {
                ref.read(onboardingNotifierProvider.notifier).setName(val);
              }
              setState(() {});
            },
          ),
        ),
        // Inline validation hint
        if (isTooShort)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              l10n.errorNameLength,
              style: AppTextStyles.inputLabel.copyWith(
                color: AppColors.error,
                fontSize: 13,
              ),
            ),
          ),
        const Spacer(),
        // Kid on-screen keyboard
        KidKeyboard(onKeyPressed: _onKeyTapped, onBackspace: _onBackspace),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── Step 1: Class Selection (Pre-KG, LKG, UKG) ─────────────────────────
  Widget _buildClassStep(
    AppLocalizations l10n,
    String selectedClass,
    dynamic notifier,
  ) {
    final classes = [
      (
        id: AppStrings.idClassPreKg,
        title: l10n.classPreKg,
        ages: l10n.agesPreKg,
        color: AppColors.cardYellow,
      ),
      (
        id: AppStrings.idClassLkg,
        title: l10n.classLkg,
        ages: l10n.agesLkg,
        color: AppColors.cardPink,
      ),
      (
        id: AppStrings.idClassUkg,
        title: l10n.classUkg,
        ages: l10n.agesUkg,
        color: AppColors.cardGreen,
      ),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: classes.map((item) {
        final isSelected = selectedClass == item.id;
        final subtitle = isSelected
            ? l10n.classWithSelected(item.ages, l10n.statusSelected)
            : item.ages;

        return ClassOptionCard(
          title: item.title,
          subtitle: subtitle,
          backgroundColor: item.color,
          isSelected: isSelected,
          onTap: () => notifier.setClass(item.id),
        );
      }).toList(),
    );
  }

  // ── Step 2: Friend Selection (2x3 Grid) ────────────────────────────────
  Widget _buildFriendStep(
    AppLocalizations l10n,
    String selectedFriend,
    dynamic notifier,
  ) {
    final friends = [
      (
        id: AppStrings.idFriendPanda,
        name: l10n.friendPanda,
        color: Colors.white,
      ),
      (
        id: AppStrings.idFriendBunny,
        name: l10n.friendBunny,
        color: AppColors.cardPeach,
      ),
      (
        id: AppStrings.idFriendLion,
        name: l10n.friendLion,
        color: AppColors.cardYellow,
      ),
      (
        id: AppStrings.idFriendFrog,
        name: l10n.friendFrog,
        color: AppColors.cardGreen,
      ),
      (
        id: AppStrings.idFriendCat,
        name: l10n.friendCat,
        color: AppColors.cardCat,
      ),
      (
        id: AppStrings.idFriendDog,
        name: l10n.friendDog,
        color: AppColors.cardPurple,
      ),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final isSelected = selectedFriend.toLowerCase() == friend.id;

        return FriendOptionCard(
          name: friend.name,
          avatarType: friend.id,
          backgroundColor: friend.color,
          isSelected: isSelected,
          onTap: () {
            notifier.setFriend(friend.id);
            // Play the real animal sound when selected
            KidSoundService.instance.playAnimalSound(friend.id);
          },
        );
      },
    );
  }
}
