import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:zuvio_kids/core/constants/app_strings.dart';
import 'package:zuvio_kids/core/utils/app_logger.dart';

/// AI Magic Service that integrates with Google AI Studio (Gemini API).
///
/// Generates fun, child-friendly animal action descriptions using the
/// configured AI Studio API key. The service rotates actions to avoid
/// repeating the same one consecutively.
///
/// API key: set [apiKey] via [configure] before first use.
/// Layer: Core Service
class AiMagicService {
  AiMagicService._();

  static final AiMagicService instance = AiMagicService._();

  static const String _geminiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  late final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  String _apiKey = AppStrings.defaultAiStudioApiKey;

  /// Set the API key for Google AI Studio.
  void configure(String apiKey) {
    if (apiKey.isNotEmpty) {
      _apiKey = apiKey;
    }
  }

  String? _lastAction;

  /// Generates a fun, child-friendly animal action for [animalName].
  /// Returns a short sentence describing the animal's movement/action.
  /// Avoids repeating [_lastAction] consecutively.
  Future<String?> generateAnimalAction(String animalName) async {
    if (_apiKey == AppStrings.defaultAiStudioApiKey ||
        _apiKey.isEmpty ||
        _apiKey == 'your_key_here') {
      // Return a fun fallback animation description when no API key is set.
      return _fallbackAction(animalName);
    }

    try {
      final avoidClause = _lastAction != null
          ? ' Do NOT use this action: "$_lastAction".'
          : '';

      final prompt =
          'You are a friendly teacher for children aged 3–6. '
          'Describe one fun, playful action a $animalName is doing RIGHT NOW. '
          'Use 1 short sentence (max 10 words). '
          'Make it exciting and child-friendly.$avoidClause '
          'Only output the sentence, nothing else.';

      final response = await _dio.post<Map<String, dynamic>>(
        '$_geminiEndpoint?key=$_apiKey',
        data: {
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 1.0,
            'maxOutputTokens': 50,
          },
        },
      );

      final text = _extractText(response.data);
      if (text != null && text.isNotEmpty) {
        _lastAction = text;
      }
      return text;
    } catch (e, st) {
      AppLogger.error('AiMagicService: generateAnimalAction failed', e, st);
      return _fallbackAction(animalName);
    }
  }

  String? _extractText(Map<String, dynamic>? data) {
    try {
      final candidates = data?['candidates'] as List<dynamic>?;
      final content = candidates?.first['content'] as Map<String, dynamic>?;
      final parts = content?['parts'] as List<dynamic>?;
      final text = parts?.first['text'] as String?;
      return text?.trim();
    } catch (_) {
      return null;
    }
  }

  /// Fallback actions used when no API key is configured.
  static const Map<String, List<String>> _fallbacks = {
    'elephant': [
      'The elephant is splashing water with its trunk! 🌊',
      'The elephant is waving hello! 🐘',
      'The elephant is dancing happily! 💃',
    ],
    'cat': [
      'The cat is leaping over a rainbow! 🌈',
      'The cat is chasing a butterfly! 🦋',
      'The cat is purring and spinning! 😺',
    ],
    'tiger': [
      'The tiger is jumping through the grass! 🌿',
      'The tiger is roaring at the stars! ⭐',
      'The tiger is doing a big leap! 🐯',
    ],
    'lion': [
      'The lion is roaring to the sky! ☁️',
      'The lion is shaking its mane! 🦁',
      'The lion is running on the savanna! 🌅',
    ],
    'cow': [
      'The cow is mooing and jumping! 🐄',
      'The cow is eating yummy grass! 🌱',
      'The cow is spinning in the field! 🌸',
    ],
    'dog': [
      'The dog is running and fetching! 🎾',
      'The dog is wagging its tail! 🐕',
      'The dog is jumping with joy! 🐾',
    ],
    'monkey': [
      'The monkey is swinging on a vine! 🍌',
      'The monkey is somersaulting! 🙈',
      'The monkey is eating a banana! 🐒',
    ],
    'rabbit': [
      'The rabbit is hopping super fast! 🐇',
      'The rabbit is wiggling its nose! 🌷',
      'The rabbit is jumping over flowers! 🌻',
    ],
    'parrot': [
      'The parrot is flying in circles! 🦜',
      'The parrot is singing a song! 🎵',
      'The parrot is flapping its wings! 🌈',
    ],
    'fish': [
      'The fish is swimming in bubbles! 🫧',
      'The fish is doing a big splash! 💦',
      'The fish is jumping out of water! 🐟',
    ],
    'default': [
      'Watch it move and play! 🎉',
      'It is jumping with joy! ⭐',
      'It is doing a special dance! 💃',
    ],
  };

  int _fallbackIndex = 0;

  String _fallbackAction(String animalName) {
    final key = animalName.toLowerCase();
    final list = _fallbacks[key] ?? _fallbacks['default']!;
    final action = list[_fallbackIndex % list.length];
    _fallbackIndex++;
    return action;
  }
}

