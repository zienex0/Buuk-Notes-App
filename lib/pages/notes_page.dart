import 'package:buuk/models/note.dart';
import 'package:buuk/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  void initState() {
    super.initState();

    // fetch notes on start up
    readNotes(context);
  }

  TextEditingController textController = TextEditingController();

  // show dialog to create note
  void showCreateNoteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  createNote(context, textController.text);
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              )
            ],
          );
        });
  }

  // show update dialog for note update
  void showUpdateNoteDialog(BuildContext context, Note note) {
    textController.text = note.title;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  await updateNoteTitle(
                      context, note.id, textController.text, note.content);
                  textController.clear();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              )
            ],
          );
        });
  }

  // create note
  Future<void> createNote(BuildContext context, String noteTitle) async {
    try {
      await context.read<NoteDatabase>().createNote(noteTitle);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note created')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // re-read all notes from provider
  Future<void> readNotes(BuildContext context) async {
    await context.read<NoteDatabase>().fetchNotes();
  }

  // update note with data
  Future<void> updateNoteTitle(
      BuildContext context, int id, String? title, String? content) async {
    try {
      await context.read<NoteDatabase>().updateNote(id, title, content);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // delete note by its id
  Future<void> deleteNote(BuildContext context, int id) async {
    try {
      await context.read<NoteDatabase>().deleteNote(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Note> currentNotes = context.watch<NoteDatabase>().currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // transparent and empty appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(),

      // add notes button
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateNoteDialog(context),
        child: const Icon(Icons.add),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // appbar alternative
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'Buuk',
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),

          // display notes in list view
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return ListTile(
                    title: Text(note.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showUpdateNoteDialog(context, note);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteNote(context, note.id);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
