import 'package:flutter/material.dart';

import 'presentation/pages/widget_gallery_screen.dart';

/// Entrypoint autonomo per il debug immediato di tutti i widget interattivi e statici.
/// Eseguibile con: flutter run -t lib/main_widgets.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WidgetGalleryApp());
}

class WidgetGalleryApp extends StatelessWidget {
  const WidgetGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laurentius — Widget Debug Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const WidgetGalleryScreen(),
    );
  }
}
