import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notes_provider.dart';
import 'screens/notes_list_screen.dart';
import 'screens/note_edit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ⚡ nécessaire pour sqflite
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: const NoteApp(),
    ),
  );
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note App",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/notes-list': (context) => const NotesListScreen(),
        '/edit': (context) => const NoteEditScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/notes-list' &&
            !Provider.of<AuthProvider>(
              context,
              listen: false,
            ).isAuthenticated) {
          // Si l'utilisateur n'est pas authentifié, le rediriger vers la page de connexion
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return null; // Laissez les autres routes être gérées par la table `routes`.
      },
    );
  }
}
