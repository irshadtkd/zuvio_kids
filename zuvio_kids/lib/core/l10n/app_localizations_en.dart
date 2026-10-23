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
}
