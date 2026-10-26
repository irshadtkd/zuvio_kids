import 'package:flutter/material.dart';
import 'package:zuvio_kids/core/constants/app_colors.dart';
import 'package:zuvio_kids/core/l10n/app_localizations.dart';
import 'package:zuvio_kids/core/theme/app_text_styles.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';
import 'package:zuvio_kids/core/widgets/kid_button.dart';
import 'package:zuvio_kids/features/alphabet/domain/entities/alphabet_letter_entity.dart';
import 'alphabet_illustration.dart';

/// Play step view: quiz & word pronunciation activity.
/// Matches Image 3 with "Which starts with [Letter]?", option cards, and star indicators.
/// Layer: Presentation Widget
class PlayStepView extends StatefulWidget {
  const PlayStepView({
    super.key,
    required this.letter,
    required this.onNext,
    required this.onWordSelected,
    required this.selectedWord,
    required this.isAnswerCorrect,
    required this.stars,
  });

  final AlphabetLetterEntity letter;
  final VoidCallback onNext;
  final ValueChanged<String> onWordSelected;
  final String? selectedWord;
  final bool? isAnswerCorrect;
  final int stars;

  @override
  State<PlayStepView> createState() => PlayStepViewState();
}

class PlayStepViewState extends State<PlayStepView> {
  static const List<Color> _cardColors = [
    AppColors.cardYellow,
    AppColors.cardGreen,
    AppColors.cardLavender,
  ];

  @override
  void initState() {
    super.initState();
    _speakQuestion();
  }

  void playAudioPrompt() {
    _speakQuestion();
  }

  void _speakQuestion() {
    final phonetic =
        KidSoundService.instance.getPhoneticLetterName(widget.letter.letter);
    final question = 'Which starts with $phonetic?';
    KidSoundService.instance.speak(question);
  }

  void _handleWordTap(String word) {
    KidSoundService.instance.speak(word);
    widget.onWordSelected(word);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = widget.letter.quizOptions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // ── Main White Card ──────────────────────────────────────────────
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Quiz Question ("Which starts with C?" or "Which starts with c?")
                  Text(
                    l10n.whichStartsWith(widget.letter.displayLetter),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headerTitle.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Large Coral Letter (C in Capital session, c in Small session)
                  Text(
                    widget.letter.displayLetter,
                    style: AppTextStyles.base.copyWith(
                      fontSize: 108,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFF5E5E),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── 3 Option Cards Row ───────────────────────────────────────────
          Row(
            children: List.generate(options.length, (index) {
              final word = options[index];
              final bgColor = _cardColors[index % _cardColors.length];
              final isChosen = widget.selectedWord == word;
              final isTargetLetterWord = word
                  .toLowerCase()
                  .startsWith(widget.letter.letter.toLowerCase());

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == options.length - 1 ? 0 : 6,
                  ),
                  child: GestureDetector(
                    onTap: () => _handleWordTap(word),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(24),
                        border: isChosen
                            ? Border.all(
                                color: isTargetLetterWord
                                    ? AppColors.kidGreen
                                    : AppColors.navy,
                                width: 3.5,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Vector Graphic / Illustration
                          AlphabetIllustration(word: word, size: 56),
                          const SizedBox(height: 8),

                          // Word Label ("Cat", "Sun", "Dog")
                          Text(
                            word,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.base.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // ── 3 Star Badges Row (matches bottom of Image 3) ────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isEarned = i < widget.stars;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  isEarned ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: isEarned ? AppColors.starYellow : AppColors.navy,
                  size: 34,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // ── Bottom Next Button ───────────────────────────────────────────
          KidButton(
            label: l10n.btnNext,
            onPressed: widget.onNext,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
