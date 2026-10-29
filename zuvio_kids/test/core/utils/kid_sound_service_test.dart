import 'package:flutter_test/flutter_test.dart';
import 'package:zuvio_kids/core/utils/kid_sound_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('KidSoundService Tests', () {
    final soundService = KidSoundService.instance;

    setUp(() {
      soundService.setMuted(true);
    });

    tearDown(() {
      soundService.setMuted(true);
    });

    test('mute state toggles properly', () {
      soundService.setMuted(false);
      expect(soundService.isMuted, isFalse);

      soundService.toggleMute();
      expect(soundService.isMuted, isTrue);

      soundService.toggleMute();
      expect(soundService.isMuted, isFalse);
    });

    test('playCelebrationSounds completes cleanly when muted', () async {
      soundService.setMuted(true);
      await expectLater(
        soundService.playCelebrationSounds('panda'),
        completes,
      );
    });

    test('playClappingSound completes cleanly when muted', () async {
      soundService.setMuted(true);
      await expectLater(
        soundService.playClappingSound(),
        completes,
      );
    });

    test('phonetic letter names provide clean character pronunciations', () {
      expect(soundService.getPhoneticLetterName('A'), 'a');
      expect(soundService.getPhoneticLetterName('B'), 'b');
      expect(soundService.getPhoneticLetterName('Z'), 'z');
    });

    test('stop executes cleanly when muted', () async {
      soundService.setMuted(true);
      await expectLater(soundService.stop(), completes);
    });
  });
}
