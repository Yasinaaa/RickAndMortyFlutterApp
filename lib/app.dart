import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickandmorty/presentation/cubit/character_cubit.dart';
import 'package:rickandmorty/presentation/pages/main_navigation_page.dart';
import '../injection_container.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => sl<CharacterCubit>()..loadMore(),
        child: const MainNavigationPage(),
      ),
    );
  }
}