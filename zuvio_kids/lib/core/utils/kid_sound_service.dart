import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// Centralised sound helper used by kid screens.
///
/// * [speak]            — TTS: read a text string aloud.
/// * [playAnimalSound]  — Play a bundled animal sound asset; falls back to
///                        TTS onomatopoeia if the asset is missing or playback
///                        fails.
/// * [stop]             — Stop any currently playing TTS or audio.
///
/// Uses a singleton so both TTS and the audio player are initialised once.
class KidSoundService {
  KidSoundService._();

  static final KidSoundService instance = KidSoundService._();

  // ── TTS ──────────────────────────────────────────────────────────────────
  final FlutterTts _tts = FlutterTts();
  bool _ttsInitialised = false;

  // ── Audio player ─────────────────────────────────────────────────────────
  final AudioPlayer _player = AudioPlayer();

  // ── Onomatopoeia fallback map (used when WAV asset is unavailable) ────────
  static const Map<String, String> _animalOnomatopoeia = {
    AppStrings.idFriendPanda: 'Mmm… mrrr!',
    AppStrings.idFriendBunny: 'Squeak squeak!',
    AppStrings.idFriendLion: 'Roaarrr!',
    AppStrings.idFriendFrog: 'Ribbit ribbit!',
    AppStrings.idFriendCat: 'Meow!',
    AppStrings.idFriendDog: 'Woof woof!',
  };

  // ── TTS initialisation ───────────────────────────────────────────────────

  /// Initialise the TTS engine once (language, rate, pitch).
  Future<void> _ensureTtsInit() async {
    if (_ttsInitialised) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.40); // Slow & clear for kids
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.20); // Slightly higher — sounds friendlier
      _ttsInitialised = true;
    } catch (e) {
      AppLogger.error('KidSoundService: TTS init failed', e);
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Speaks [text] aloud via TTS, stopping any current speech first.
  Future<void> speak(String text) async {
    await _ensureTtsInit();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      AppLogger.error('KidSoundService: speak failed', e);
    }
  }

  /// Plays the real animal sound for [animalId] (e.g. `'lion'`, `'dog'`).
  ///
  /// The audio file is expected at `assets/audio/animals/<animalId>.wav`.
  /// Falls back to TTS onomatopoeia if playback fails.
  Future<void> playAnimalSound(String animalId) async {
    final id = animalId.toLowerCase();
    final assetPath = '${AppStrings.assetsAudio}animals/$id.wav';

    try {
      await _tts.stop(); // Silence any ongoing TTS
      await _player.stop();
      await _player.setAsset(assetPath);
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (e) {
      AppLogger.error(
        'KidSoundService: playAnimalSound failed for "$id", falling back to TTS',
        e,
      );
      // Graceful fallback: speak the onomatopoeia
      final fallback = _animalOnomatopoeia[id] ?? id;
      await speak(fallback);
    }
  }

  /// Stops any currently playing TTS or audio.
  Future<void> stop() async {
    try {
      await _tts.stop();
      await _player.stop();
    } catch (e) {
      AppLogger.error('KidSoundService: stop failed', e);
    }
  }

  /// Disposes the audio player. Call when the app is shutting down.
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (e) {
      AppLogger.error('KidSoundService: dispose failed', e);
    }
  }
}
