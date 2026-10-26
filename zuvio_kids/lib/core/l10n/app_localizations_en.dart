// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ZuvioKids';

  @override
  String get btnRetry => 'Retry';

  @override
  String get btnNext => 'Next';

  @override
  String get btnBack => 'Back';

  @override
  String get btnClose => 'Close';

  @override
  String get btnStart => 'Start';

  @override
  String get errorNetworkUnavailable =>
      'No internet connection. Please try again.';

  @override
  String get errorCacheFailure =>
      'Could not load saved data. Please try again.';

  @override
  String get errorPermissionDenied =>
      'Permission denied. Please check your settings.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again later.';

  @override
  String get errorPageNotFound => '404 — Page not found';

  @override
  String get titleSplashAdventure => 'Kids Learning Adventure';

  @override
  String get subtitleSplash => 'See, listen, touch, play!';

  @override
  String get captionSplash => 'No ads. Works offline.';

  @override
  String get headingWelcomeFriend => 'Hello, friend!';

  @override
  String get msgWelcomePanda => 'I am Panda. Let us learn and play together!';

  @override
  String get btnForParents => 'For parents';

  @override
  String get titleYourName => 'Your name';

  @override
  String get speechBubbleName => 'A grown-up can type my friend\'s name.';

  @override
  String get labelName => 'Name';

  @override
  String get hintChildName => 'Mia';

  @override
  String get titleMyClass => 'My class';

  @override
  String get speechBubbleClass => 'Which class are you in?';

  @override
  String get classPreKg => 'Pre-KG';

  @override
  String get agesPreKg => 'Ages 3-4';

  @override
  String get classLkg => 'LKG';

  @override
  String get agesLkg => 'Ages 4-5';

  @override
  String get classUkg => 'UKG';

  @override
  String get agesUkg => 'Ages 5-6';

  @override
  String get statusSelected => 'Selected';

  @override
  String get titleMyFriend => 'My friend';

  @override
  String get speechBubbleFriend => 'Pick a cartoon friend to learn with!';

  @override
  String get friendPanda => 'Panda';

  @override
  String get friendBunny => 'Bunny';

  @override
  String get friendLion => 'Lion';

  @override
  String get friendFrog => 'Frog';

  @override
  String get friendCat => 'Cat';

  @override
  String get friendDog => 'Dog';

  @override
  String get btnDone => 'Done!';

  @override
  String homeWelcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get homeSubtitle => 'Let us learn and play together!';

  @override
  String get homeCardActivities => 'Fun Activities';

  @override
  String get homeCardStories => 'Bedtime Stories';

  @override
  String get homeCardGames => 'Play Games';

  @override
  String get btnResetProfile => 'Reset Profile';

  @override
  String get titleParentsSection => 'For Parents';

  @override
  String get msgParentsSection =>
      'Parent settings and controls will be available here.';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name!';
  }

  @override
  String get homePlayAndLearn => 'Let us play and learn';

  @override
  String get categoryAlphabet => 'Alphabet';

  @override
  String get categoryNumbers => 'Numbers';

  @override
  String get categoryShapes => 'Shapes';

  @override
  String get categoryColors => 'Colors';

  @override
  String get categoryAnimals => 'Animals';

  @override
  String get categoryPuzzles => 'Puzzles';

  @override
  String get labelMyGarden => 'My Garden';

  @override
  String get tooltipGardenLocked =>
      'My Garden is locked. Keep learning to unlock!';

  @override
  String get visualAlphabetAbc => 'A B C';

  @override
  String get visualNumbers123 => '1 2 3';

  @override
  String get visualAnimalsMoo => 'Moo';

  @override
  String notifyActivityStarting(String activity) {
    return '$activity activity is starting!';
  }

  @override
  String classWithSelected(String ages, String status) {
    return '$ages ✓ $status';
  }

  @override
  String get menuChangeName => 'Change Name';

  @override
  String get menuLogout => 'Logout';

  @override
  String get errorNameLength => 'Name must be 2–10 characters.';
}
