import 'package:flutter_tts/flutter_tts.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// Centralised text-to-speech helper used by kid screens.
///
/// Call [speak] to say a word aloud and [stop] to interrupt.
/// Uses a singleton so TTS is only initialised once per app session.
class KidSoundService {
  KidSoundService._();

  static final KidSoundService instance = KidSoundService._();

  final FlutterTts _tts = FlutterTts();
  bool _initialised = false;

  /// Initialise the TTS engine once (language, rate, pitch).
  Future<void> _ensureInit() async {
    if (_initialised) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.40); // Slow & clear for kids
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.20); // Slightly higher — sounds friendlier
      _initialised = true;
    } catch (e) {
      AppLogger.error('KidSoundService: init failed', e);
    }
  }

  /// Speaks [text] aloud, stopping any current speech first.
  Future<void> speak(String text) async {
    await _ensureInit();
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      AppLogger.error('KidSoundService: speak failed', e);
    }
  }

  /// Stops any currently playing speech.
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      AppLogger.error('KidSoundService: stop failed', e);
    }
  }
}
