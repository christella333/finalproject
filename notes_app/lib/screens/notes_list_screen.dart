// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
// ignore: unused_import
import '../models/note.dart';
import '../providers/auth_provider.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});
  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotesProvider>(context, listen: false).loadNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesProv = Provider.of<NotesProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => notesProv.loadNotes(),
        child: notesProv.notes.isEmpty
            ? const Center(
                child: Text(
                  'Aucune note pour le moment. Appuie sur + pour ajouter.',
                ),
              )
            : ListView.builder(
                itemCount: notesProv.notes.length,
                itemBuilder: (context, i) {
                  final note = notesProv.notes[i];
                  return Dismissible(
                    key: ValueKey(note.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) async {
                      await notesProv.deleteNote(note.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note supprimée')),
                      );
                    },
                    child: ListTile(
                      title: Text(note.title),
                      subtitle: Text(
                        note.content.length > 80
                            ? '${note.content.substring(0, 80)}...'
                            : note.content,
                        maxLines: 2,
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/edit',
                        arguments: note,
                      ).then((_) => notesProv.loadNotes()),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ajouter une note',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(
          context,
          '/edit',
        ).then((_) => notesProv.loadNotes()),
      ),
    );
  }
}
