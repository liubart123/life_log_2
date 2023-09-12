import 'package:flutter/material.dart';

import 'test_of_flutter_possibilities/flutter_theme_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x09201a),
          // tertiary: Colors.amber,
          brightness: Brightness.dark,
        ),
        // hintColor: Colors.amber,
        //brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const FlutterThemeTest(),
    );
  }
}
