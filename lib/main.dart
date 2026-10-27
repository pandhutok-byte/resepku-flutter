import 'package:flutter/material.dart';

import 'view/home.dart';

void main() {
  runApp(const ResepKuApp());
}

class ResepKuApp extends StatelessWidget {
  const ResepKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2E7D32);

    return MaterialApp(
      title: 'ResepKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        scaffoldBackgroundColor: const Color(0xFFF7F8F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: const Home(),
    );
  }
}
