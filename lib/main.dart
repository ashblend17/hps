import 'package:flutter/material.dart';
import 'screens/nav_root.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme lightScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
    );
    final ColorScheme darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Hotel Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkScheme),
      themeMode: ThemeMode.system,
      home: const NavRoot(),
    );
  }
}
