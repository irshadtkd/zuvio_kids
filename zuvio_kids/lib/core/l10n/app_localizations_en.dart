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
  String get menuChangeTheme => 'Change Theme';

  @override
  String get themeDialogTitle => 'Choose Theme';

  @override
  String get themeDialogSubtitle => 'Pick your favourite colors!';

  @override
  String get themeSunnySky => 'Sunny Sky';

  @override
  String get themeSunnySkyDesc => 'Bright sky blue adventure';

  @override
  String get themeCandyCarnival => 'Candy Carnival';

  @override
  String get themeCandyCarnivalDesc => 'Sweet pink & playful candy';

  @override
  String get themeMagicMeadow => 'Magic Meadow';

  @override
  String get themeMagicMeadowDesc => 'Fresh green playful meadow';

  @override
  String get themeSelected => 'Active';

  @override
  String get errorNameLength => 'Name must be 2–10 characters.';

  @override
  String get titleAlphabet => 'Alphabet';

  @override
  String get stepDiscover => '1 Discover';

  @override
  String get stepPractice => '2 Practice';

  @override
  String get stepPlay => '3 Play';

  @override
  String get btnNextLevel => 'Next level';

  @override
  String get btnPlayAgain => 'Play again';

  @override
  String get btnSaveProgress => 'Save Progress';

  @override
  String get btnSaveAndContinue => 'Save & Continue';

  @override
  String congratsTitle(String name) {
    return 'Great job, $name!';
  }

  @override
  String get starsEarnedBadge => '+10 Stars Earned!';

  @override
  String sessionCompleteUnlocked(String completed, String next) {
    return 'Session $completed done. Session $next is unlocked!';
  }

  @override
  String get allSessionsComplete =>
      'Level 4 done. All alphabet sessions complete!';

  @override
  String traceLetterPrompt(String letter, String word) {
    return 'Trace $letter. $letter for $word!';
  }

  @override
  String get practiceHelperPrompt => 'Trace the dotted line with your finger!';

  @override
  String get tracingSuccess => 'Great Job!';

  @override
  String get tracingTryAgain => 'Try Again!';

  @override
  String whichStartsWith(String letter) {
    return 'Which starts with $letter?';
  }

  @override
  String letterForWord(String letter, String word) {
    return '$letter for $word';
  }

  @override
  String get session1Title => 'Capital Letters (A–L)';

  @override
  String get session1Subtitle => 'First 12 capital letters';

  @override
  String get session2Title => 'Capital Letters (M–Z)';

  @override
  String get session2Subtitle => 'Remaining 14 capital letters';

  @override
  String get session3Title => 'Small Letters (a–l)';

  @override
  String get session3Subtitle => 'First 12 small letters';

  @override
  String get session4Title => 'Small Letters (m–z)';

  @override
  String get session4Subtitle => 'Remaining 14 small letters';

  @override
  String get sessionStatusCompleted => 'Completed';

  @override
  String get sessionStatusInProgress => 'In Progress';

  @override
  String get sessionStatusLocked => 'Locked';

  @override
  String get sessionStatusStart => 'Start';

  @override
  String get notifySessionSaved => 'Progress saved! Keep up the good work!';

  @override
  String totalStarsCount(int count) {
    return '$count Stars';
  }

  @override
  String get btnReplayAudio => 'Replay Audio';

  @override
  String get alphabetSessionsHeading => 'Alphabet Sessions';

  @override
  String get btnMute => 'Mute sound';

  @override
  String get btnUnmute => 'Unmute sound';

  @override
  String get numbersHubTitle => 'Numbers 1-100';

  @override
  String get numbersHubSubtitle => 'Pick a level. Stars unlock the next one!';

  @override
  String get meetTheNumber => 'Meet the number';

  @override
  String get tapNumberToHearAgain => 'Tap the number to hear it again';

  @override
  String get traceTheNumber => 'Trace the number';

  @override
  String get followDotsWithFinger => 'Follow the dots with your finger!';

  @override
  String get btnShowMe => 'Show me';

  @override
  String get findTheNumber => 'Find the number';

  @override
  String get whichNumberIsThis => 'Which number is this?';

  @override
  String get countAgainYouCanDoIt => 'Count them again. You can do it!';

  @override
  String get numbersCongratsTitle => 'Congratulations!';

  @override
  String numbersCongratsSubtitle(String session) {
    return 'You completed session $session!';
  }

  @override
  String get numbersStarsEarned => '+10 Stars Earned!';

  @override
  String get btnClear => 'Clear';

  @override
  String get colorMagic => 'Color Magic';

  @override
  String get discoverTheColor => 'Discover the color';

  @override
  String paintTheObject(String object, String color) {
    return 'Paint the $object $color!';
  }

  @override
  String tapColorThenObject(String object) {
    return 'Tap a color, then tap the $object.';
  }

  @override
  String get tapColorToHearAgain => 'Tap the color to hear it again';

  @override
  String get colorsCongratsSubtitle => 'You learned all 7 colors!';

  @override
  String get colorRed => 'Red';

  @override
  String get colorYellow => 'Yellow';

  @override
  String get colorGreen => 'Green';

  @override
  String get colorBlue => 'Blue';

  @override
  String get colorOrange => 'Orange';

  @override
  String get colorPurple => 'Purple';

  @override
  String get colorPink => 'Pink';

  @override
  String get objectApple => 'apple';

  @override
  String get objectBanana => 'banana';

  @override
  String get objectLeaf => 'leaf';

  @override
  String get objectBalloon => 'balloon';

  @override
  String get objectCarrot => 'carrot';

  @override
  String get objectGrapes => 'grapes';

  @override
  String get objectFlower => 'flower';

  @override
  String get shapesHubTitle => 'Shapes Fun';

  @override
  String get shapesHubSubtitle => 'Explore shapes! 3 steps to master each one.';

  @override
  String get shapesDiscoverTitle => 'Discover Shape';

  @override
  String thisIsA(String shapeName) {
    return 'This is a $shapeName!';
  }

  @override
  String shapeExampleDesc(String exampleName) {
    return 'Like a $exampleName!';
  }

  @override
  String get tapShapeToHear => 'Tap the shape to hear its name!';

  @override
  String get shapesPracticeTitle => 'Practice Shape';

  @override
  String get shapesTraceInstruction => 'Trace the dotted shape!';

  @override
  String get shapesMatchingTitle => 'Shape Matching';

  @override
  String shapesMatchInstruction(String shapeName) {
    return 'Find the $shapeName!';
  }

  @override
  String shapesMatchCorrect(String shapeName) {
    return 'Super! That\'s the $shapeName!';
  }

  @override
  String get shapesCongratsTitle => 'Shapes Champion!';

  @override
  String get shapesCongratsSubtitle =>
      'You completed this session and earned 10 stars!';

  @override
  String get btnNextSession => 'Next Session';

  @override
  String get shapeCircle => 'Circle';

  @override
  String get shapeSquare => 'Square';

  @override
  String get shapeTriangle => 'Triangle';

  @override
  String get shapeRectangle => 'Rectangle';

  @override
  String get shapeOval => 'Oval';

  @override
  String get shapeStar => 'Star';

  @override
  String get shapeHeart => 'Heart';

  @override
  String get shapeDiamond => 'Diamond';

  @override
  String get shapePentagon => 'Pentagon';

  @override
  String get shapeHexagon => 'Hexagon';

  @override
  String get shapeCrescent => 'Crescent';

  @override
  String get shapeSemicircle => 'Semicircle';

  @override
  String get exampleClock => 'Clock';

  @override
  String get exampleBall => 'Ball';

  @override
  String get exampleGiftBox => 'Gift Box';

  @override
  String get examplePizza => 'Pizza Slice';

  @override
  String get exampleDoor => 'Door';

  @override
  String get exampleEgg => 'Egg';

  @override
  String get exampleStarfish => 'Starfish';

  @override
  String get exampleBalloon => 'Balloon';

  @override
  String get exampleKite => 'Kite';

  @override
  String get exampleBirdhouse => 'Birdhouse';

  @override
  String get exampleHoneycomb => 'Honeycomb';

  @override
  String get exampleMoon => 'Moon';

  @override
  String get exampleWatermelon => 'Watermelon Slice';

  @override
  String get shapeFilledLabel => 'Solid';

  @override
  String get shapeOutlineLabel => 'Outline';

  @override
  String get titlePuzzlePlayground => 'Puzzle\nPlayground';

  @override
  String get instructionMatchShadows => 'Match each picture to its shadow!';

  @override
  String get headingShadows => 'Shadows';

  @override
  String get headingPictures => 'Pictures';

  @override
  String labelPuzzleSession(String number) {
    return 'Puzzle $number';
  }

  @override
  String get feedbackPuzzleMatched => 'Awesome! You matched the shadow!';

  @override
  String get feedbackPuzzleTryAgain => 'Oops, try matching another shadow!';

  @override
  String get feedbackPuzzleComplete => 'Great job! All shadows matched!';

  @override
  String get puzzleCongratsTitle => 'Puzzle Master!';

  @override
  String get puzzleCongratsSubtitle =>
      'You solved all 4 puzzles and earned 10 stars!';

  @override
  String get titleAnimals => 'Animals';

  @override
  String get animalsHubSubtitle => 'Meet your friendly animal friends!';

  @override
  String get animalsSession1Title => 'Session 1';

  @override
  String get animalsSession1Subtitle => 'Elephant, Cat, Tiger & Friends';

  @override
  String get animalsSession2Title => 'Session 2';

  @override
  String get animalsSession2Subtitle => 'Rabbit, Parrot, Fish & Friends';

  @override
  String animalsItemProgress(int current, int total) {
    return '$current of $total';
  }

  @override
  String get btnPlaySound => 'Play Sound';

  @override
  String get animalCongratsTitle => 'Animal Explorer!';

  @override
  String get animalCongratsSubtitle =>
      'You learned all 10 animals in this session and earned 5 stars!';

  @override
  String get animalElephant => 'Elephant';

  @override
  String get animalCat => 'Cat';

  @override
  String get animalTiger => 'Tiger';

  @override
  String get animalLion => 'Lion';

  @override
  String get animalCow => 'Cow';

  @override
  String get animalGoat => 'Goat';

  @override
  String get animalMonkey => 'Monkey';

  @override
  String get animalDog => 'Dog';

  @override
  String get animalHen => 'Hen';

  @override
  String get animalHorse => 'Horse';

  @override
  String get animalRabbit => 'Rabbit';

  @override
  String get animalParrot => 'Parrot';

  @override
  String get animalFish => 'Fish';

  @override
  String get animalGiraffe => 'Giraffe';

  @override
  String get animalZebra => 'Zebra';

  @override
  String get animalDeer => 'Deer';

  @override
  String get animalPeacock => 'Peacock';

  @override
  String get animalFrog => 'Frog';

  @override
  String get animalCamel => 'Camel';

  @override
  String get animalBear => 'Bear';

  @override
  String mascotGreetingHome(String name) {
    return 'Hello $name! What do you want to learn today?';
  }

  @override
  String get mascotGreetingAnimals => 'Let\'s meet some amazing animals!';

  @override
  String get mascotGreetingAlphabet => 'Let\'s learn the A B C s!';

  @override
  String get mascotGreetingNumbers => 'Time for numbers! Count with me!';

  @override
  String get mascotGreetingColors => 'Let\'s discover beautiful colors!';

  @override
  String get mascotGreetingShapes => 'Wow, you found the shapes! Let\'s go!';

  @override
  String get mascotGreetingPuzzles => 'Puzzle time! You love puzzles!';

  @override
  String get mascotCelebrate => 'Amazing! You did it! You are a superstar!';

  @override
  String get mascotEncourage => 'You can do it! Try again!';

  @override
  String get feedbackCorrect1 => 'Yes! That is right! You are so smart!';

  @override
  String get feedbackCorrect2 => 'Woohoo! Amazing answer!';

  @override
  String get feedbackCorrect3 => 'Brilliant! Give yourself a clap!';

  @override
  String get feedbackCorrect4 => 'Perfect! You are a genius!';

  @override
  String get feedbackCorrect5 => 'Incredible! Fantastic job!';

  @override
  String get feedbackWrong1 => 'Almost! Have another look!';

  @override
  String get feedbackWrong2 => 'Hmm, let us try again — you can do it!';

  @override
  String get feedbackWrong3 => 'Do not worry, try once more!';

  @override
  String get achievementAnimalExplorer => 'Animal Explorer';

  @override
  String get achievementAnimalMaster => 'Animal Master';

  @override
  String get achievementAlphabetStar => 'Alphabet Star';

  @override
  String get achievementNumberNinja => 'Number Ninja';

  @override
  String get achievementColorArtist => 'Color Artist';

  @override
  String get achievementShapeFinder => 'Shape Finder';

  @override
  String get achievementPuzzleChampion => 'Puzzle Champion';

  @override
  String get achievementStarCollector => 'Star Collector';

  @override
  String get achievementOnFire => 'On Fire!';

  @override
  String get trophyRoomTitle => 'My Trophy Room';

  @override
  String get trophyRoomSubtitle => 'Look at all your amazing badges!';

  @override
  String get badgeLockedHint => 'Keep learning to unlock!';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Days Streak!',
      one: '1 Day Streak!',
    );
    return '$_temp0';
  }

  @override
  String get streakNewRecord => 'New streak record!';

  @override
  String get levelLittleLearner => 'Little Learner';

  @override
  String get levelRisingStar => 'Rising Star';

  @override
  String get levelExplorer => 'Explorer';

  @override
  String get levelHero => 'Learning Hero';

  @override
  String get levelChampion => 'ZuvioKids Champion';

  @override
  String get levelUp => 'Level Up!';

  @override
  String levelLabel(String level) {
    return 'Level: $level';
  }

  @override
  String get dailyAdventureTitle => 'Today\'s Adventure';

  @override
  String get dailyAdventureSubtitle =>
      'Complete today\'s activities to earn bonus stars!';

  @override
  String get dailyAdventureComplete => 'All done! Amazing work today!';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name! Ready to learn?';
  }

  @override
  String get animalsQuizTitle => 'Which animal makes this sound?';

  @override
  String get animalsQuizHint => 'Listen and tap the animal!';

  @override
  String get animalsQuizPlaySound => 'Play Sound Again';
}
