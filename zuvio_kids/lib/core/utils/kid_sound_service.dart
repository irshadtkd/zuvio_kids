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
      await _tts.awaitSpeakCompletion(true);
      _ttsInitialised = true;
    } catch (e) {
      AppLogger.error('KidSoundService: TTS init failed', e);
    }
  }

  // ── Mute State ────────────────────────────────────────────────────────────
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  /// Toggles mute on/off and silences any current audio if muting.
  void toggleMute() {
    _isMuted = !_isMuted;
    if (_isMuted) {
      stop();
    }
  }

  /// Sets mute state explicitly.
  void setMuted(bool muted) {
    _isMuted = muted;
    if (_isMuted) {
      stop();
    }
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Speaks [text] aloud via TTS, stopping any current speech first.
  /// Respects the mute/unmute setting.
  Future<void> speak(String text) async {
    if (_isMuted) return;
    await _ensureTtsInit();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      AppLogger.error('KidSoundService: speak failed', e);
    }
  }

  // ── Phonetic Letter Pronunciations ───────────────────────────────────────
  // Native TTS engines on Android/iOS announce "Capital [Letter]" or "Small [Letter]"
  // when an isolated single character is passed. Using dictionary phonetic names
  // ensures the engine pronounces ONLY the clean character name ("A", "B", "C")
  // without any "Capital" or "Small" prefix on any device.
  static const Map<String, String> _phoneticLetterNames = {
    'A': 'a',
    'B': 'b',
    'C': 'c',
    'D': 'd',
    'E': 'e',
    'F': 'f',
    'G': 'g',
    'H': 'h',
    'I': 'i',
    'J': 'j',
    'K': 'k',
    'L': 'l',
    'M': 'm',
    'N': 'n',
    'O': 'o',
    'P': 'p',
    'Q': 'q',
    'R': 'r',
    'S': 's',
    'T': 't',
    'U': 'u',
    'V': 'v',
    'W': 'w',
    'X': 'x',
    'Y': 'y',
    'Z': 'z',
  };

  /// Returns the dictionary phonetic name for a letter (e.g. 'ay' for 'A'/'a').
  String getPhoneticLetterName(String letter) {
    final key = letter.trim().toUpperCase();
    return _phoneticLetterNames[key] ?? key;
  }

  /// Speaks a letter name aloud (e.g. 'A', 'B', 'C') without any prefix
  /// like 'Capital' or 'Small'.
  Future<void> speakLetter(String letter) async {
    final phonetic = getPhoneticLetterName(letter);
    await speak(phonetic);
  }

  /// Speaks the supporting phrase (e.g. "A for Apple") using pure letter
  /// pronunciation without any "Capital" or "Small" prefix.
  Future<void> speakLetterPhrase(String letter, String word) async {
    final phonetic = getPhoneticLetterName(letter);
    await speak('$phonetic for $word');
  }

  /// Plays the real animal sound for [animalId] (e.g. `'lion'`, `'dog'`).
  ///
  /// The audio file is expected at `assets/audio/animals/<animalId>.wav`.
  /// Falls back to TTS onomatopoeia if playback fails.
  Future<void> playAnimalSound(String animalId) async {
    if (_isMuted) return;
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
