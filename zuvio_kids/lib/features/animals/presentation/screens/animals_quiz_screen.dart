import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/constants/app_sizes.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/theme/app_theme_palette.dart';
import 'package:zuvio_kids/core/utils/feedback_voice_bank.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_confetti_overlay.dart';
import 'package:zuvio_kids/features/animals/domain/entities/animal_entity.dart';
import 'package:zuvio_kids/features/animals/presentation/providers/animals_provider.dart';

/// Mini-quiz screen: plays an animal sound and asks the child to pick the correct animal.
/// Presented after completing a block of 5 animals in the learning session.
/// Layer: Presentation Screen
class AnimalsQuizScreen extends ConsumerStatefulWidget {
  const AnimalsQuizScreen({super.key, required this.onQuizComplete});

  /// Called when the quiz is done so the parent screen can advance the session.
  final VoidCallback onQuizComplete;

  @override
  ConsumerState<AnimalsQuizScreen> createState() => _AnimalsQuizScreenState();
}

class _AnimalsQuizScreenState extends ConsumerState<AnimalsQuizScreen>
    with TickerProviderStateMixin {
  late AnimalEntity _correctAnimal;
  late List<AnimalEntity> _options;
  AnimalEntity? _selectedAnimal;
  bool? _isCorrect;

  final _confettiKey = GlobalKey<KidConfettiOverlayState>();
  late final AnimationController _feedbackController;
  late final Animation<double> _feedbackScale;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _feedbackScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupQuiz();
      _playCorrectAnimalSound();
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _setupQuiz() {
    final state = ref.read(animalsNotifierProvider).valueOrNull;
    final session = state?.selectedSession;
    if (session == null) return;

    final rng = Random();
    final allAnimals = session.animals;
    _correctAnimal = allAnimals[rng.nextInt(allAnimals.length)];

    // Pick 2 random wrong answers from the rest
    final others = allAnimals.where((a) => a.id != _correctAnimal.id).toList()
      ..shuffle();
    final wrongs = others.take(2).toList();
    _options = [...wrongs, _correctAnimal]..shuffle();
    setState(() {});
  }

  void _playCorrectAnimalSound() {
    KidSoundService.instance.playAnimalSound(_correctAnimal.id);
  }

  void _handleOptionTap(AnimalEntity picked) {
    if (_selectedAnimal != null) return; // Already answered
    final correct = picked.id == _correctAnimal.id;
    setState(() {
      _selectedAnimal = picked;
      _isCorrect = correct;
    });
    _feedbackController.forward();

    if (correct) {
      KidSoundService.instance.speak(FeedbackVoiceBank.randomCorrect());
      _confettiKey.currentState?.smallBurst();
    } else {
      KidSoundService.instance.speak(FeedbackVoiceBank.randomEncourage());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.themePalette;

    return Scaffold(
      backgroundColor: palette.scaffoldBackground,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingL,
                vertical: AppSizes.paddingM,
              ),
              child: Column(
                children: [
                  // Title
                  Text(
                    l10n.animalsQuizTitle,
                    style: AppTextStyles.splashTitle.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.animalsQuizHint,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Big Sound Button
                  GestureDetector(
                    onTap: _playCorrectAnimalSound,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.volume_up_rounded,
                        size: 56,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.animalsQuizPlaySound,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3 Option Cards
                  Expanded(
                    child: _options.isEmpty
                        ? const SizedBox.shrink()
                        : Row(
                            children: _options.map((animal) {
                              final isSelected = _selectedAnimal?.id == animal.id;
                              final isThis = _selectedAnimal != null &&
                                  animal.id == _correctAnimal.id;
                              Color borderColor = Colors.transparent;
                              if (isSelected) {
                                borderColor = _isCorrect == true
                                    ? AppColors.kidGreen
                                    : AppColors.error;
                              } else if (isThis && _selectedAnimal != null) {
                                borderColor = AppColors.kidGreen;
                              }

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: GestureDetector(
                                    onTap: () => _handleOptionTap(animal),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(28),
                                        border: Border.all(
                                          color: borderColor,
                                          width: 3.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.06),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            animal.svgAsset,
                                            width: 80,
                                            height: 80,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            animal.englishName,
                                            style: AppTextStyles.base.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.navy,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Feedback + Continue
                  if (_selectedAnimal != null)
                    ScaleTransition(
                      scale: _feedbackScale,
                      child: Column(
                        children: [
                          Text(
                            _isCorrect == true ? '🎉' : '💪',
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: widget.onQuizComplete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.kidGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              l10n.btnNext,
                              style: AppTextStyles.buttonLabel.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          KidConfettiOverlay(key: _confettiKey),
        ],
      ),
    );
  }
}
