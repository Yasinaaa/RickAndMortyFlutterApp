import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart' as di; // инициализация зависимостей
// import 'presentation/app.dart'; // корневой виджет приложения

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // инициализация DI, например с get_it
  runApp(const App());
}