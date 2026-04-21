import 'package:flutter/material.dart';
import 'shared/theme.dart';

// Ekrany projektow
import 'features/projekt1/projekt1_screen.dart';
import 'features/projekt2/projekt2_screen.dart';
import 'features/projekt3/projekt3_screen.dart';
import 'features/projekt4/projekt4_screen.dart';
import 'features/projekt5/projekt5_screen.dart';
import 'features/projekt6/projekt6_screen.dart';

// Ekran glowny
import 'features/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moja Aplikacja',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/projekt1': (context) => const Projekt1Screen(),
        '/projekt2': (context) => const Projekt2Screen(),
        '/projekt3': (context) => const Projekt3Screen(),
        '/projekt4': (context) => const Projekt4Screen(),
        '/projekt5': (context) => const Projekt5Screen(),
        '/projekt6': (context) => const Projekt6Screen(),
      },
    );
  }
}