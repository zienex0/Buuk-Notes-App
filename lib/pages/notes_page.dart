import 'package:buuk/models/note.dart';
import 'package:buuk/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // fetch notes on start up
    readNotes(context);
  }

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

  // delete note
  Future<void> deleteNote(BuildContext context, int id) async {
    // TODO implement deleting notes logic
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),

      // add notes button
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateNoteDialog(context),
        child: const Icon(Icons.add),
      ),

      // display notes in list view
      body: Consumer<NoteDatabase>(
        builder: (context, noteDatabase, child) {
          return ListView.builder(
              itemCount: noteDatabase.currentNotes.length,
              itemBuilder: (context, index) {
                final note = noteDatabase.currentNotes[index];
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
              });
        },
      ),
    );
  }
}
