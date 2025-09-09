import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key});
  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  Note? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && arg is Note && editing == null) {
      editing = arg;
      _titleCtrl.text = editing!.title;
      _contentCtrl.text = editing!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProv = Provider.of<NotesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(editing == null ? 'Nouvelle note' : 'Modifier la note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  hintText: 'Entrez le titre de la note',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _contentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Contenu',
                  hintText: 'Entrez le contenu de la note',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                //expands: true,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      final note = Note(
                        id: editing?.id,
                        title: _titleCtrl.text.trim(),
                        content: _contentCtrl.text.trim(),
                        date: '',
                      );
                      if (editing == null) {
                        await notesProv.addNote(note);
                      } else {
                        await notesProv.updateNote(note);
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    child: const Text('Sauvegarder'),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
