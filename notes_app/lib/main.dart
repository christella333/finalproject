import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ⚡ nécessaire pour sqflite
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Note App",
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
