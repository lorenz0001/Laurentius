import 'package:flutter/material.dart';

void main() {
  runApp(const LaurentiusApp());
}

class LaurentiusApp extends StatelessWidget {
  const LaurentiusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brilliant OS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brilliant OS'),
      ),
      body: const Center(
        child: Text('Brilliant OS'),
      ),
    );
  }
}
