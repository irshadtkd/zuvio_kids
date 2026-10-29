import 'package:zuvio_kids/features/colors/domain/entities/color_item_entity.dart';
import 'package:zuvio_kids/features/colors/domain/entities/color_session_entity.dart';

/// Presentation state for Colors learning feature.
/// Layer: Presentation
class ColorsState {
  const ColorsState({
    required this.studentName,
    required this.session,
    required this.totalStars,
    this.currentColorIndex = 0,
    this.currentStep = 0, // 0 = Discover, 1 = Paint
    this.selectedPaletteColorValue,
    this.appliedColorValue,
    this.isPaintCorrect,
    this.isSessionCompleted = false,
  });

  final String studentName;
  final ColorSessionEntity session;
  final int totalStars;
  final int currentColorIndex;
  final int currentStep;
  final int? selectedPaletteColorValue;
  final int? appliedColorValue;
  final bool? isPaintCorrect;
  final bool isSessionCompleted;

  ColorItemEntity get currentColor {
    final idx = currentColorIndex.clamp(0, session.colors.length - 1);
    return session.colors[idx];
  }

  bool get isLastColorInSession =>
      currentColorIndex >= session.colors.length - 1;

  ColorsState copyWith({
    String? studentName,
    ColorSessionEntity? session,
    int? totalStars,
    int? currentColorIndex,
    int? currentStep,
    int? selectedPaletteColorValue,
    int? appliedColorValue,
    bool? isPaintCorrect,
    bool? isSessionCompleted,
    bool clearSelectedPaletteColor = false,
    bool clearAppliedColor = false,
    bool clearIsPaintCorrect = false,
  }) {
    return ColorsState(
      studentName: studentName ?? this.studentName,
      session: session ?? this.session,
      totalStars: totalStars ?? this.totalStars,
      currentColorIndex: currentColorIndex ?? this.currentColorIndex,
      currentStep: currentStep ?? this.currentStep,
      selectedPaletteColorValue: clearSelectedPaletteColor
          ? null
          : (selectedPaletteColorValue ?? this.selectedPaletteColorValue),
      appliedColorValue: clearAppliedColor
          ? null
          : (appliedColorValue ?? this.appliedColorValue),
      isPaintCorrect: clearIsPaintCorrect
          ? null
          : (isPaintCorrect ?? this.isPaintCorrect),
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
