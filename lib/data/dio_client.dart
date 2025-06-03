import 'dart:ui';
import 'package:dio/dio.dart';

Dio createDioClient() {
  final String systemLanguage = PlatformDispatcher.instance.locale.languageCode.toLowerCase();
  final String selectedLanguage = (systemLanguage == 'ru') ? 'ru' : 'en';
  final dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept-Language': selectedLanguage,
    },
  ));
  return dio;
}