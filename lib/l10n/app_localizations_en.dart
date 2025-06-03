// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Rick & Morty';

  @override
  String get sortBy => 'Sort by:';

  @override
  String get byName => 'By name';

  @override
  String get byStatus => 'By status';

  @override
  String get favorites => 'Favorites';

  @override
  String get characters => 'Characters';

  @override
  String get loadingError => 'Failed to load characters';

  @override
  String status(Object value) {
    return 'Status: $value';
  }

  @override
  String species(Object value) {
    return 'Species: $value';
  }

  @override
  String location(Object value) {
    return 'Location: $value';
  }
}
