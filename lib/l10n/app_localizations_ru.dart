// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Рик и Морти';

  @override
  String get sortBy => 'Сортировка:';

  @override
  String get byName => 'По имени';

  @override
  String get byStatus => 'По статусу';

  @override
  String get favorites => 'Избранное';

  @override
  String get characters => 'Персонажи';

  @override
  String get loadingError => 'Ошибка загрузки';

  @override
  String status(Object value) {
    return 'Статус: $value';
  }

  @override
  String species(Object value) {
    return 'Вид: $value';
  }

  @override
  String location(Object value) {
    return 'Локация: $value';
  }
}
