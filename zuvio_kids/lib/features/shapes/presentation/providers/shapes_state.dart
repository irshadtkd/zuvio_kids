import 'package:zuvio_kids/features/shapes/domain/entities/shape_entity.dart';
import 'package:zuvio_kids/features/shapes/domain/entities/shape_session_entity.dart';

/// Presentation state for Shapes learning feature.
/// Layer: Presentation
class ShapesState {
  const ShapesState({
    required this.studentName,
    required this.sessions,
    required this.totalStars,
    this.activeSession,
    this.currentShapeIndex = 0,
    this.currentStep = 0, // 0 = Discover, 1 = Practice, 2 = Matching
    this.isTracingComplete = false,
    this.selectedMatchingOption,
    this.isAnswerCorrect,
    this.isSessionCompleted = false,
  });

  final String studentName;
  final List<ShapeSessionEntity> sessions;
  final int totalStars;
  final ShapeSessionEntity? activeSession;
  final int currentShapeIndex;
  final int currentStep;
  final bool isTracingComplete;
  final String? selectedMatchingOption;
  final bool? isAnswerCorrect;
  final bool isSessionCompleted;

  ShapeEntity? get currentShape {
    if (activeSession == null) return null;
    if (currentShapeIndex < 0 ||
        currentShapeIndex >= activeSession!.shapes.length) {
      return null;
    }
    return activeSession!.shapes[currentShapeIndex];
  }

  bool get isLastShapeInSession {
    if (activeSession == null) return false;
    return currentShapeIndex >= activeSession!.shapes.length - 1;
  }

  ShapesState copyWith({
    String? studentName,
    List<ShapeSessionEntity>? sessions,
    int? totalStars,
    ShapeSessionEntity? activeSession,
    int? currentShapeIndex,
    int? currentStep,
    bool? isTracingComplete,
    String? selectedMatchingOption,
    bool? isAnswerCorrect,
    bool? isSessionCompleted,
    bool clearActiveSession = false,
    bool clearSelectedMatchingOption = false,
    bool clearIsAnswerCorrect = false,
  }) {
    return ShapesState(
      studentName: studentName ?? this.studentName,
      sessions: sessions ?? this.sessions,
      totalStars: totalStars ?? this.totalStars,
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      currentShapeIndex: currentShapeIndex ?? this.currentShapeIndex,
      currentStep: currentStep ?? this.currentStep,
      isTracingComplete: isTracingComplete ?? this.isTracingComplete,
      selectedMatchingOption: clearSelectedMatchingOption
          ? null
          : (selectedMatchingOption ?? this.selectedMatchingOption),
      isAnswerCorrect: clearIsAnswerCorrect
          ? null
          : (isAnswerCorrect ?? this.isAnswerCorrect),
      isSessionCompleted: isSessionCompleted ?? this.isSessionCompleted,
    );
  }
}
