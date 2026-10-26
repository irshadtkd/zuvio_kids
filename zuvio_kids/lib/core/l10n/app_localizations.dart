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

  /// Validation error shown when name is too short or too long
  ///
  /// In en, this message translates to:
  /// **'Name must be 2–10 characters.'**
  String get errorNameLength;
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
