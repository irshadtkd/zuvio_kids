import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emotions the interactive companion mascot can express.
enum MascotEmotion {
  idle,
  speaking,
  celebrating,
  encouraging,
}

/// State representing the living mascot companion.
class MascotState {
  const MascotState({
    this.emotion = MascotEmotion.idle,
    this.speechMessage,
  });

  final MascotEmotion emotion;
  final String? speechMessage;

  MascotState copyWith({
    MascotEmotion? emotion,
    String? speechMessage,
    bool clearMessage = false,
  }) {
    return MascotState(
      emotion: emotion ?? this.emotion,
      speechMessage: clearMessage ? null : (speechMessage ?? this.speechMessage),
    );
  }
}

/// Riverpod notifier to control the living mascot's emotion and speech bubble.
/// Layer: Core Provider
class MascotNotifier extends Notifier<MascotState> {
  @override
  MascotState build() => const MascotState();

  /// Mascot celebrates a correct action (jumping + star burst).
  void celebrate([String? message]) {
    state = state.copyWith(
      emotion: MascotEmotion.celebrating,
      speechMessage: message,
    );
  }

  /// Mascot encourages the child after an incorrect or idle state.
  void encourage([String? message]) {
    state = state.copyWith(
      emotion: MascotEmotion.encouraging,
      speechMessage: message,
    );
  }

  /// Mascot speaks a message through its speech bubble.
  void speak(String message) {
    state = state.copyWith(
      emotion: MascotEmotion.speaking,
      speechMessage: message,
    );
  }

  /// Mascot returns to resting idle breathing bob.
  void idle() {
    state = const MascotState();
  }
}

final mascotNotifierProvider =
    NotifierProvider<MascotNotifier, MascotState>(MascotNotifier.new);
