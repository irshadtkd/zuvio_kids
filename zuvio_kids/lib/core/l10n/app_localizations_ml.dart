// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'ZuvioKids';

  @override
  String get btnRetry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get btnNext => 'അടുത്തത്';

  @override
  String get btnBack => 'പിന്നോട്ട്';

  @override
  String get btnClose => 'അടയ്ക്കുക';

  @override
  String get btnStart => 'ആരംഭിക്കുക';

  @override
  String get errorNetworkUnavailable =>
      'ഇന്റർനെറ്റ് കണക്ഷൻ ഇല്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorCacheFailure =>
      'സംരക്ഷിച്ച ഡേറ്റ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errorPermissionDenied =>
      'അനുമതി നിരസിച്ചു. ക്രമീകരണങ്ങൾ പരിശോധിക്കുക.';

  @override
  String get errorUnexpected =>
      'എന്തോ തകരാറ് സംഭവിച്ചു. കുറച്ചു കഴിഞ്ഞ് വീണ്ടും ശ്രമിക്കുക.';
}
