import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'ZuvioKids'**
  String get appName;

  /// Label for the Retry button shown on error screens
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get btnRetry;

  /// Label for the Next navigation button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get btnNext;

  /// Label for the Back navigation button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get btnBack;

  /// Label for the Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// Label for the Start button
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get btnStart;

  /// Error message shown when the device has no network connection
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please try again.'**
  String get errorNetworkUnavailable;

  /// Error message shown when local cache cannot be read
  ///
  /// In en, this message translates to:
  /// **'Could not load saved data. Please try again.'**
  String get errorCacheFailure;

  /// Error message shown when the app lacks a required permission
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please check your settings.'**
  String get errorPermissionDenied;

  /// Generic fallback error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again later.'**
  String get errorUnexpected;

  /// Error message when route is not found
  ///
  /// In en, this message translates to:
  /// **'404 — Page not found'**
  String get errorPageNotFound;

  /// Title on the splash screen
  ///
  /// In en, this message translates to:
  /// **'Kids Learning Adventure'**
  String get titleSplashAdventure;

  /// Subtitle on the splash screen
  ///
  /// In en, this message translates to:
  /// **'See, listen, touch, play!'**
  String get subtitleSplash;

  /// Footer caption on the splash screen
  ///
  /// In en, this message translates to:
  /// **'No ads. Works offline.'**
  String get captionSplash;

  /// Heading on the welcome card
  ///
  /// In en, this message translates to:
  /// **'Hello, friend!'**
  String get headingWelcomeFriend;

  /// Welcome message spoken by Panda
  ///
  /// In en, this message translates to:
  /// **'I am Panda. Let us learn and play together!'**
  String get msgWelcomePanda;

  /// Button to open the parents section
  ///
  /// In en, this message translates to:
  /// **'For parents'**
  String get btnForParents;

  /// Title for name input step
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get titleYourName;

  /// Instruction in speech bubble on name step
  ///
  /// In en, this message translates to:
  /// **'A grown-up can type my friend\'s name.'**
  String get speechBubbleName;

  /// Label for child name input
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// Placeholder hint for name input
  ///
  /// In en, this message translates to:
  /// **'Mia'**
  String get hintChildName;

  /// Title for class selection step
  ///
  /// In en, this message translates to:
  /// **'My class'**
  String get titleMyClass;

  /// Speech bubble prompt for class selection
  ///
  /// In en, this message translates to:
  /// **'Which class are you in?'**
  String get speechBubbleClass;

  /// Pre-KG class label
  ///
  /// In en, this message translates to:
  /// **'Pre-KG'**
  String get classPreKg;

  /// Age range for Pre-KG
  ///
  /// In en, this message translates to:
  /// **'Ages 3-4'**
  String get agesPreKg;

  /// LKG class label
  ///
  /// In en, this message translates to:
  /// **'LKG'**
  String get classLkg;

  /// Age range for LKG
  ///
  /// In en, this message translates to:
  /// **'Ages 4-5'**
  String get agesLkg;

  /// UKG class label
  ///
  /// In en, this message translates to:
  /// **'UKG'**
  String get classUkg;

  /// Age range for UKG
  ///
  /// In en, this message translates to:
  /// **'Ages 5-6'**
  String get agesUkg;

  /// Text indicating item is selected
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get statusSelected;

  /// Title for friend selection step
  ///
  /// In en, this message translates to:
  /// **'My friend'**
  String get titleMyFriend;

  /// Speech bubble prompt for friend selection
  ///
  /// In en, this message translates to:
  /// **'Pick a cartoon friend to learn with!'**
  String get speechBubbleFriend;

  /// Name of Panda character
  ///
  /// In en, this message translates to:
  /// **'Panda'**
  String get friendPanda;

  /// Name of Bunny character
  ///
  /// In en, this message translates to:
  /// **'Bunny'**
  String get friendBunny;

  /// Name of Lion character
  ///
  /// In en, this message translates to:
  /// **'Lion'**
  String get friendLion;

  /// Name of Frog character
  ///
  /// In en, this message translates to:
  /// **'Frog'**
  String get friendFrog;

  /// Name of Cat character
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get friendCat;

  /// Name of Dog character
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get friendDog;

  /// Label for Done action button
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get btnDone;

  /// Home greeting for the child
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String homeWelcomeBack(String name);

  /// Subtitle on home screen
  ///
  /// In en, this message translates to:
  /// **'Let us learn and play together!'**
  String get homeSubtitle;

  /// Label for activities card
  ///
  /// In en, this message translates to:
  /// **'Fun Activities'**
  String get homeCardActivities;

  /// Label for stories card
  ///
  /// In en, this message translates to:
  /// **'Bedtime Stories'**
  String get homeCardStories;

  /// Label for games card
  ///
  /// In en, this message translates to:
  /// **'Play Games'**
  String get homeCardGames;

  /// Button to clear saved profile and restart onboarding
  ///
  /// In en, this message translates to:
  /// **'Reset Profile'**
  String get btnResetProfile;

  /// Title for parents dialog
  ///
  /// In en, this message translates to:
  /// **'For Parents'**
  String get titleParentsSection;

  /// Message in parents dialog
  ///
  /// In en, this message translates to:
  /// **'Parent settings and controls will be available here.'**
  String get msgParentsSection;

  /// Home screen greeting with child name
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}!'**
  String homeGreeting(String name);

  /// Subtitle below child greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Let us play and learn'**
  String get homePlayAndLearn;

  /// Title for Alphabet learning category
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get categoryAlphabet;

  /// Title for Numbers learning category
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get categoryNumbers;

  /// Title for Shapes learning category
  ///
  /// In en, this message translates to:
  /// **'Shapes'**
  String get categoryShapes;

  /// Title for Colors learning category
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get categoryColors;

  /// Title for Animals learning category
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get categoryAnimals;

  /// Title for Puzzles learning category
  ///
  /// In en, this message translates to:
  /// **'Puzzles'**
  String get categoryPuzzles;

  /// Label for My Garden reward section
  ///
  /// In en, this message translates to:
  /// **'My Garden'**
  String get labelMyGarden;

  /// Tooltip when tapping locked garden button
  ///
  /// In en, this message translates to:
  /// **'My Garden is locked. Keep learning to unlock!'**
  String get tooltipGardenLocked;

  /// Visual letters on the alphabet card
  ///
  /// In en, this message translates to:
  /// **'A B C'**
  String get visualAlphabetAbc;

  /// Visual numbers on the numbers card
  ///
  /// In en, this message translates to:
  /// **'1 2 3'**
  String get visualNumbers123;

  /// Visual animal sound on the animals card
  ///
  /// In en, this message translates to:
  /// **'Moo'**
  String get visualAnimalsMoo;

  /// Snackbar notification when tapping an activity
  ///
  /// In en, this message translates to:
  /// **'{activity} activity is starting!'**
  String notifyActivityStarting(String activity);

  /// Formatted age with selected status
  ///
  /// In en, this message translates to:
  /// **'{ages} ✓ {status}'**
  String classWithSelected(String ages, String status);

  /// Profile bottom sheet option to change name
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get menuChangeName;

  /// Profile bottom sheet option to log out / clear profile
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get menuLogout;

  /// Profile bottom sheet option to change the app color theme
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get menuChangeTheme;

  /// Header title of the theme selection modal
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get themeDialogTitle;

  /// Subtitle encouraging kids to pick a color theme
  ///
  /// In en, this message translates to:
  /// **'Pick your favourite colors!'**
  String get themeDialogSubtitle;

  /// Name of the default blue theme
  ///
  /// In en, this message translates to:
  /// **'Sunny Sky'**
  String get themeSunnySky;

  /// Description of the default blue theme
  ///
  /// In en, this message translates to:
  /// **'Bright sky blue adventure'**
  String get themeSunnySkyDesc;

  /// Name of the pink candy theme
  ///
  /// In en, this message translates to:
  /// **'Candy Carnival'**
  String get themeCandyCarnival;

  /// Description of the pink candy theme
  ///
  /// In en, this message translates to:
  /// **'Sweet pink & playful candy'**
  String get themeCandyCarnivalDesc;

  /// Name of the green meadow theme
  ///
  /// In en, this message translates to:
  /// **'Magic Meadow'**
  String get themeMagicMeadow;

  /// Description of the green meadow theme
  ///
  /// In en, this message translates to:
  /// **'Fresh green playful meadow'**
  String get themeMagicMeadowDesc;

  /// Label indicating which theme is currently selected
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get themeSelected;

  /// Validation error shown when name is too short or too long
  ///
  /// In en, this message translates to:
  /// **'Name must be 2–10 characters.'**
  String get errorNameLength;

  /// Title on the alphabet screens
  ///
  /// In en, this message translates to:
  /// **'Alphabet'**
  String get titleAlphabet;

  /// Label for Discover learning step tab
  ///
  /// In en, this message translates to:
  /// **'1 Discover'**
  String get stepDiscover;

  /// Label for Practice learning step tab
  ///
  /// In en, this message translates to:
  /// **'2 Practice'**
  String get stepPractice;

  /// Label for Play learning step tab
  ///
  /// In en, this message translates to:
  /// **'3 Play'**
  String get stepPlay;

  /// Button to advance to next level/session
  ///
  /// In en, this message translates to:
  /// **'Next level'**
  String get btnNextLevel;

  /// Button to replay completed session
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get btnPlayAgain;

  /// Button to save student learning progress
  ///
  /// In en, this message translates to:
  /// **'Save Progress'**
  String get btnSaveProgress;

  /// Button to save progress and proceed
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get btnSaveAndContinue;

  /// Congratulations screen title with child name
  ///
  /// In en, this message translates to:
  /// **'Great job, {name}!'**
  String congratsTitle(String name);

  /// Star reward badge on congratulations screen
  ///
  /// In en, this message translates to:
  /// **'+10 Stars Earned!'**
  String get starsEarnedBadge;

  /// Subtitle announcing unlocked session
  ///
  /// In en, this message translates to:
  /// **'Session {completed} done. Session {next} is unlocked!'**
  String sessionCompleteUnlocked(String completed, String next);

  /// Message when all 4 sessions are finished
  ///
  /// In en, this message translates to:
  /// **'Level 4 done. All alphabet sessions complete!'**
  String get allSessionsComplete;

  /// Instruction prompt below tracing pattern
  ///
  /// In en, this message translates to:
  /// **'Trace {letter}. {letter} for {word}!'**
  String traceLetterPrompt(String letter, String word);

  /// Speech bubble helper prompt on practice screen
  ///
  /// In en, this message translates to:
  /// **'Trace the dotted line with your finger!'**
  String get practiceHelperPrompt;

  /// Feedback message when letter tracing reaches 99% or above
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get tracingSuccess;

  /// Feedback message when letter tracing is below 99%
  ///
  /// In en, this message translates to:
  /// **'Try Again!'**
  String get tracingTryAgain;

  /// Quiz question on play screen
  ///
  /// In en, this message translates to:
  /// **'Which starts with {letter}?'**
  String whichStartsWith(String letter);

  /// Letter phrase in discover screen
  ///
  /// In en, this message translates to:
  /// **'{letter} for {word}'**
  String letterForWord(String letter, String word);

  /// Title for session 1
  ///
  /// In en, this message translates to:
  /// **'Capital Letters (A–L)'**
  String get session1Title;

  /// Subtitle for session 1
  ///
  /// In en, this message translates to:
  /// **'First 12 capital letters'**
  String get session1Subtitle;

  /// Title for session 2
  ///
  /// In en, this message translates to:
  /// **'Capital Letters (M–Z)'**
  String get session2Title;

  /// Subtitle for session 2
  ///
  /// In en, this message translates to:
  /// **'Remaining 14 capital letters'**
  String get session2Subtitle;

  /// Title for session 3
  ///
  /// In en, this message translates to:
  /// **'Small Letters (a–l)'**
  String get session3Title;

  /// Subtitle for session 3
  ///
  /// In en, this message translates to:
  /// **'First 12 small letters'**
  String get session3Subtitle;

  /// Title for session 4
  ///
  /// In en, this message translates to:
  /// **'Small Letters (m–z)'**
  String get session4Title;

  /// Subtitle for session 4
  ///
  /// In en, this message translates to:
  /// **'Remaining 14 small letters'**
  String get session4Subtitle;

  /// Badge indicating session is completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get sessionStatusCompleted;

  /// Badge indicating session is in progress
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get sessionStatusInProgress;

  /// Badge indicating session is locked
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get sessionStatusLocked;

  /// Action button to start session
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get sessionStatusStart;

  /// Notification when alphabet progress is saved
  ///
  /// In en, this message translates to:
  /// **'Progress saved! Keep up the good work!'**
  String get notifySessionSaved;

  /// Display count of stars
  ///
  /// In en, this message translates to:
  /// **'{count} Stars'**
  String totalStarsCount(int count);

  /// Accessibility tooltip for audio replay button
  ///
  /// In en, this message translates to:
  /// **'Replay Audio'**
  String get btnReplayAudio;

  /// Heading on the alphabet sessions hub screen
  ///
  /// In en, this message translates to:
  /// **'Alphabet Sessions'**
  String get alphabetSessionsHeading;

  /// Accessibility label for mute button
  ///
  /// In en, this message translates to:
  /// **'Mute sound'**
  String get btnMute;

  /// Accessibility label for unmute button
  ///
  /// In en, this message translates to:
  /// **'Unmute sound'**
  String get btnUnmute;

  /// Title on the numbers hub screen
  ///
  /// In en, this message translates to:
  /// **'Numbers 1-100'**
  String get numbersHubTitle;

  /// Subtitle on the numbers hub screen
  ///
  /// In en, this message translates to:
  /// **'Pick a level. Stars unlock the next one!'**
  String get numbersHubSubtitle;

  /// Header for discover number step
  ///
  /// In en, this message translates to:
  /// **'Meet the number'**
  String get meetTheNumber;

  /// Helper text on discover number step
  ///
  /// In en, this message translates to:
  /// **'Tap the number to hear it again'**
  String get tapNumberToHearAgain;

  /// Header for practice tracing step
  ///
  /// In en, this message translates to:
  /// **'Trace the number'**
  String get traceTheNumber;

  /// Helper speech bubble on tracing step
  ///
  /// In en, this message translates to:
  /// **'Follow the dots with your finger!'**
  String get followDotsWithFinger;

  /// Button to demonstrate tracing pattern
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get btnShowMe;

  /// Header for play quiz step
  ///
  /// In en, this message translates to:
  /// **'Find the number'**
  String get findTheNumber;

  /// Question on play quiz step
  ///
  /// In en, this message translates to:
  /// **'Which number is this?'**
  String get whichNumberIsThis;

  /// Encouraging speech bubble on play quiz step
  ///
  /// In en, this message translates to:
  /// **'Count them again. You can do it!'**
  String get countAgainYouCanDoIt;

  /// Title on congratulations screen
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get numbersCongratsTitle;

  /// Subtitle on congratulations screen
  ///
  /// In en, this message translates to:
  /// **'You completed session {session}!'**
  String numbersCongratsSubtitle(String session);

  /// Stars badge text on congratulations screen
  ///
  /// In en, this message translates to:
  /// **'+10 Stars Earned!'**
  String get numbersStarsEarned;

  /// Label and tooltip for the reset or clear tracing button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get btnClear;

  /// Title on the paint step screen
  ///
  /// In en, this message translates to:
  /// **'Color Magic'**
  String get colorMagic;

  /// Title on discover color step screen
  ///
  /// In en, this message translates to:
  /// **'Discover the color'**
  String get discoverTheColor;

  /// Prompt instructing child to paint the object with a specific color
  ///
  /// In en, this message translates to:
  /// **'Paint the {object} {color}!'**
  String paintTheObject(String object, String color);

  /// Helper instruction for painting the object
  ///
  /// In en, this message translates to:
  /// **'Tap a color, then tap the {object}.'**
  String tapColorThenObject(String object);

  /// Helper text on discover color step
  ///
  /// In en, this message translates to:
  /// **'Tap the color to hear it again'**
  String get tapColorToHearAgain;

  /// Subtitle on colors congratulations screen
  ///
  /// In en, this message translates to:
  /// **'You learned all 7 colors!'**
  String get colorsCongratsSubtitle;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// Color name
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'apple'**
  String get objectApple;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'banana'**
  String get objectBanana;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'leaf'**
  String get objectLeaf;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'balloon'**
  String get objectBalloon;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'carrot'**
  String get objectCarrot;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'grapes'**
  String get objectGrapes;

  /// Object name
  ///
  /// In en, this message translates to:
  /// **'flower'**
  String get objectFlower;

  /// Title on Shapes Hub screen
  ///
  /// In en, this message translates to:
  /// **'Shapes Fun'**
  String get shapesHubTitle;

  /// Subtitle on Shapes Hub screen
  ///
  /// In en, this message translates to:
  /// **'Explore shapes! 3 steps to master each one.'**
  String get shapesHubSubtitle;

  /// Title for Discover Shape step
  ///
  /// In en, this message translates to:
  /// **'Discover Shape'**
  String get shapesDiscoverTitle;

  /// Announcement of the shape
  ///
  /// In en, this message translates to:
  /// **'This is a {shapeName}!'**
  String thisIsA(String shapeName);

  /// Real world example phrase
  ///
  /// In en, this message translates to:
  /// **'Like a {exampleName}!'**
  String shapeExampleDesc(String exampleName);

  /// Helper instruction on discover step
  ///
  /// In en, this message translates to:
  /// **'Tap the shape to hear its name!'**
  String get tapShapeToHear;

  /// Title for Practice Shape step
  ///
  /// In en, this message translates to:
  /// **'Practice Shape'**
  String get shapesPracticeTitle;

  /// Instruction for tracing shape
  ///
  /// In en, this message translates to:
  /// **'Trace the dotted shape!'**
  String get shapesTraceInstruction;

  /// Title for Matching step
  ///
  /// In en, this message translates to:
  /// **'Shape Matching'**
  String get shapesMatchingTitle;

  /// Instruction for matching shape
  ///
  /// In en, this message translates to:
  /// **'Find the {shapeName}!'**
  String shapesMatchInstruction(String shapeName);

  /// Feedback message when matching shape is correct
  ///
  /// In en, this message translates to:
  /// **'Super! That\'s the {shapeName}!'**
  String shapesMatchCorrect(String shapeName);

  /// Title on Shapes congratulations screen
  ///
  /// In en, this message translates to:
  /// **'Shapes Champion!'**
  String get shapesCongratsTitle;

  /// Subtitle on Shapes congratulations screen
  ///
  /// In en, this message translates to:
  /// **'You completed this session and earned 10 stars!'**
  String get shapesCongratsSubtitle;

  /// Button to advance to next session
  ///
  /// In en, this message translates to:
  /// **'Next Session'**
  String get btnNextSession;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Circle'**
  String get shapeCircle;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Square'**
  String get shapeSquare;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Triangle'**
  String get shapeTriangle;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get shapeRectangle;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Oval'**
  String get shapeOval;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get shapeStar;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get shapeHeart;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Diamond'**
  String get shapeDiamond;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Pentagon'**
  String get shapePentagon;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Hexagon'**
  String get shapeHexagon;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Crescent'**
  String get shapeCrescent;

  /// Shape name
  ///
  /// In en, this message translates to:
  /// **'Semicircle'**
  String get shapeSemicircle;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Clock'**
  String get exampleClock;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Ball'**
  String get exampleBall;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Gift Box'**
  String get exampleGiftBox;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Pizza Slice'**
  String get examplePizza;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get exampleDoor;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get exampleEgg;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Starfish'**
  String get exampleStarfish;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Balloon'**
  String get exampleBalloon;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Kite'**
  String get exampleKite;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Birdhouse'**
  String get exampleBirdhouse;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Honeycomb'**
  String get exampleHoneycomb;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get exampleMoon;

  /// Real world item name
  ///
  /// In en, this message translates to:
  /// **'Watermelon Slice'**
  String get exampleWatermelon;

  /// Label for filled solid shape representation
  ///
  /// In en, this message translates to:
  /// **'Solid'**
  String get shapeFilledLabel;

  /// Label for outline unfilled shape representation
  ///
  /// In en, this message translates to:
  /// **'Outline'**
  String get shapeOutlineLabel;

  /// Screen title for the puzzle sessions screen
  ///
  /// In en, this message translates to:
  /// **'Puzzle\nPlayground'**
  String get titlePuzzlePlayground;

  /// Instruction message for matching shadows puzzle
  ///
  /// In en, this message translates to:
  /// **'Match each picture to its shadow!'**
  String get instructionMatchShadows;

  /// Heading for shadow target slots
  ///
  /// In en, this message translates to:
  /// **'Shadows'**
  String get headingShadows;

  /// Heading for draggable/selectable pictures
  ///
  /// In en, this message translates to:
  /// **'Pictures'**
  String get headingPictures;

  /// Label for puzzle session pill
  ///
  /// In en, this message translates to:
  /// **'Puzzle {number}'**
  String labelPuzzleSession(String number);

  /// Positive feedback when a shadow match is correct
  ///
  /// In en, this message translates to:
  /// **'Awesome! You matched the shadow!'**
  String get feedbackPuzzleMatched;

  /// Gentle guidance when dropped on wrong shadow
  ///
  /// In en, this message translates to:
  /// **'Oops, try matching another shadow!'**
  String get feedbackPuzzleTryAgain;

  /// Feedback when current puzzle session is completed
  ///
  /// In en, this message translates to:
  /// **'Great job! All shadows matched!'**
  String get feedbackPuzzleComplete;

  /// Title on puzzle congratulations screen
  ///
  /// In en, this message translates to:
  /// **'Puzzle Master!'**
  String get puzzleCongratsTitle;

  /// Subtitle on puzzle congratulations screen
  ///
  /// In en, this message translates to:
  /// **'You solved all 4 puzzles and earned 10 stars!'**
  String get puzzleCongratsSubtitle;

  /// Title on the animals hub screen
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get titleAnimals;

  /// Subtitle on the animals hub screen
  ///
  /// In en, this message translates to:
  /// **'Meet your friendly animal friends!'**
  String get animalsHubSubtitle;

  /// Title for session 1 of animals
  ///
  /// In en, this message translates to:
  /// **'Session 1'**
  String get animalsSession1Title;

  /// Subtitle for session 1 of animals
  ///
  /// In en, this message translates to:
  /// **'Elephant, Cat, Tiger & Friends'**
  String get animalsSession1Subtitle;

  /// Title for session 2 of animals
  ///
  /// In en, this message translates to:
  /// **'Session 2'**
  String get animalsSession2Title;

  /// Subtitle for session 2 of animals
  ///
  /// In en, this message translates to:
  /// **'Rabbit, Parrot, Fish & Friends'**
  String get animalsSession2Subtitle;

  /// Current item position in learning session
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String animalsItemProgress(int current, int total);

  /// Button to play the animal sound effect
  ///
  /// In en, this message translates to:
  /// **'Play Sound'**
  String get btnPlaySound;

  /// Title on animals congratulations screen
  ///
  /// In en, this message translates to:
  /// **'Animal Explorer!'**
  String get animalCongratsTitle;

  /// Subtitle on animals congratulations screen
  ///
  /// In en, this message translates to:
  /// **'You learned all 10 animals in this session and earned 5 stars!'**
  String get animalCongratsSubtitle;

  /// Name for Elephant
  ///
  /// In en, this message translates to:
  /// **'Elephant'**
  String get animalElephant;

  /// Name for Cat
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get animalCat;

  /// Name for Tiger
  ///
  /// In en, this message translates to:
  /// **'Tiger'**
  String get animalTiger;

  /// Name for Lion
  ///
  /// In en, this message translates to:
  /// **'Lion'**
  String get animalLion;

  /// Name for Cow
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get animalCow;

  /// Name for Goat
  ///
  /// In en, this message translates to:
  /// **'Goat'**
  String get animalGoat;

  /// Name for Monkey
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get animalMonkey;

  /// Name for Dog
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get animalDog;

  /// Name for Hen
  ///
  /// In en, this message translates to:
  /// **'Hen'**
  String get animalHen;

  /// Name for Horse
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get animalHorse;

  /// Name for Rabbit
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get animalRabbit;

  /// Name for Parrot
  ///
  /// In en, this message translates to:
  /// **'Parrot'**
  String get animalParrot;

  /// Name for Fish
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get animalFish;

  /// Name for Giraffe
  ///
  /// In en, this message translates to:
  /// **'Giraffe'**
  String get animalGiraffe;

  /// Name for Zebra
  ///
  /// In en, this message translates to:
  /// **'Zebra'**
  String get animalZebra;

  /// Name for Deer
  ///
  /// In en, this message translates to:
  /// **'Deer'**
  String get animalDeer;

  /// Name for Peacock
  ///
  /// In en, this message translates to:
  /// **'Peacock'**
  String get animalPeacock;

  /// Name for Frog
  ///
  /// In en, this message translates to:
  /// **'Frog'**
  String get animalFrog;

  /// Name for Camel
  ///
  /// In en, this message translates to:
  /// **'Camel'**
  String get animalCamel;

  /// Name for Bear
  ///
  /// In en, this message translates to:
  /// **'Bear'**
  String get animalBear;

  /// Mascot greeting on home screen
  ///
  /// In en, this message translates to:
  /// **'Hello {name}! What do you want to learn today?'**
  String mascotGreetingHome(String name);

  /// Mascot greeting when entering the Animals section
  ///
  /// In en, this message translates to:
  /// **'Let\'s meet some amazing animals!'**
  String get mascotGreetingAnimals;

  /// Mascot greeting when entering the Alphabet section
  ///
  /// In en, this message translates to:
  /// **'Let\'s learn the A B C s!'**
  String get mascotGreetingAlphabet;

  /// Mascot greeting when entering the Numbers section
  ///
  /// In en, this message translates to:
  /// **'Time for numbers! Count with me!'**
  String get mascotGreetingNumbers;

  /// Mascot greeting when entering the Colors section
  ///
  /// In en, this message translates to:
  /// **'Let\'s discover beautiful colors!'**
  String get mascotGreetingColors;

  /// Mascot greeting when entering the Shapes section
  ///
  /// In en, this message translates to:
  /// **'Wow, you found the shapes! Let\'s go!'**
  String get mascotGreetingShapes;

  /// Mascot greeting when entering the Puzzles section
  ///
  /// In en, this message translates to:
  /// **'Puzzle time! You love puzzles!'**
  String get mascotGreetingPuzzles;

  /// Mascot celebration when session completes
  ///
  /// In en, this message translates to:
  /// **'Amazing! You did it! You are a superstar!'**
  String get mascotCelebrate;

  /// Mascot encouragement on wrong answer
  ///
  /// In en, this message translates to:
  /// **'You can do it! Try again!'**
  String get mascotEncourage;

  /// First correct answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Yes! That is right! You are so smart!'**
  String get feedbackCorrect1;

  /// Second correct answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Woohoo! Amazing answer!'**
  String get feedbackCorrect2;

  /// Third correct answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Brilliant! Give yourself a clap!'**
  String get feedbackCorrect3;

  /// Fourth correct answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Perfect! You are a genius!'**
  String get feedbackCorrect4;

  /// Fifth correct answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Incredible! Fantastic job!'**
  String get feedbackCorrect5;

  /// First wrong answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Almost! Have another look!'**
  String get feedbackWrong1;

  /// Second wrong answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Hmm, let us try again — you can do it!'**
  String get feedbackWrong2;

  /// Third wrong answer feedback phrase
  ///
  /// In en, this message translates to:
  /// **'Do not worry, try once more!'**
  String get feedbackWrong3;

  /// Badge name for completing Animals Session 1
  ///
  /// In en, this message translates to:
  /// **'Animal Explorer'**
  String get achievementAnimalExplorer;

  /// Badge name for completing Animals Session 2
  ///
  /// In en, this message translates to:
  /// **'Animal Master'**
  String get achievementAnimalMaster;

  /// Badge name for completing any Alphabet session
  ///
  /// In en, this message translates to:
  /// **'Alphabet Star'**
  String get achievementAlphabetStar;

  /// Badge name for completing Numbers
  ///
  /// In en, this message translates to:
  /// **'Number Ninja'**
  String get achievementNumberNinja;

  /// Badge name for completing Colors
  ///
  /// In en, this message translates to:
  /// **'Color Artist'**
  String get achievementColorArtist;

  /// Badge name for completing Shapes
  ///
  /// In en, this message translates to:
  /// **'Shape Finder'**
  String get achievementShapeFinder;

  /// Badge name for completing Puzzles
  ///
  /// In en, this message translates to:
  /// **'Puzzle Champion'**
  String get achievementPuzzleChampion;

  /// Badge name for earning 50 total stars
  ///
  /// In en, this message translates to:
  /// **'Star Collector'**
  String get achievementStarCollector;

  /// Badge name for 3 sessions in one day
  ///
  /// In en, this message translates to:
  /// **'On Fire!'**
  String get achievementOnFire;

  /// Title for the trophy room screen
  ///
  /// In en, this message translates to:
  /// **'My Trophy Room'**
  String get trophyRoomTitle;

  /// Subtitle for the trophy room screen
  ///
  /// In en, this message translates to:
  /// **'Look at all your amazing badges!'**
  String get trophyRoomSubtitle;

  /// Hint shown under a locked badge
  ///
  /// In en, this message translates to:
  /// **'Keep learning to unlock!'**
  String get badgeLockedHint;

  /// Streak counter label
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Day Streak!} other{{count} Days Streak!}}'**
  String streakDays(int count);

  /// Label shown when a new streak record is set
  ///
  /// In en, this message translates to:
  /// **'New streak record!'**
  String get streakNewRecord;

  /// Level 1 title (0-15 stars)
  ///
  /// In en, this message translates to:
  /// **'Little Learner'**
  String get levelLittleLearner;

  /// Level 2 title (16-35 stars)
  ///
  /// In en, this message translates to:
  /// **'Rising Star'**
  String get levelRisingStar;

  /// Level 3 title (36-60 stars)
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get levelExplorer;

  /// Level 4 title (61-100 stars)
  ///
  /// In en, this message translates to:
  /// **'Learning Hero'**
  String get levelHero;

  /// Level 5 title (100+ stars)
  ///
  /// In en, this message translates to:
  /// **'ZuvioKids Champion'**
  String get levelChampion;

  /// Message shown when levelling up
  ///
  /// In en, this message translates to:
  /// **'Level Up!'**
  String get levelUp;

  /// Label showing current level name
  ///
  /// In en, this message translates to:
  /// **'Level: {level}'**
  String levelLabel(String level);

  /// Title for the daily adventure card on home screen
  ///
  /// In en, this message translates to:
  /// **'Today\'s Adventure'**
  String get dailyAdventureTitle;

  /// Subtitle for the daily adventure card
  ///
  /// In en, this message translates to:
  /// **'Complete today\'s activities to earn bonus stars!'**
  String get dailyAdventureSubtitle;

  /// Message when daily adventure is fully completed
  ///
  /// In en, this message translates to:
  /// **'All done! Amazing work today!'**
  String get dailyAdventureComplete;

  /// Welcome back message when child returns after a day
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}! Ready to learn?'**
  String welcomeBack(String name);

  /// Title prompt for the animals sound quiz
  ///
  /// In en, this message translates to:
  /// **'Which animal makes this sound?'**
  String get animalsQuizTitle;

  /// Hint for the animals sound quiz
  ///
  /// In en, this message translates to:
  /// **'Listen and tap the animal!'**
  String get animalsQuizHint;

  /// Button to replay the animal sound in quiz
  ///
  /// In en, this message translates to:
  /// **'Play Sound Again'**
  String get animalsQuizPlaySound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
