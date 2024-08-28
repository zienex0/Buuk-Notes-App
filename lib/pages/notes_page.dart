import 'package:buuk/models/note_database.dart';
import 'package:flutter/material.dart';
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

  // build dialog to create note
  void showCreateNoteDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();
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

  // create note
  void createNote(BuildContext context, String noteTitle) async {
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

  // read all notes from provider database
  void readNotes(BuildContext context) {
    context.read<NoteDatabase>().fetchNotes();
  }

  // update note
  void updateNote() {
    // TODO implement update notes logic
  }

  // delete note
  void deleteNote() {
    // TODO implement deleting notes logic
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
                );
              });
        },
      ),
    );
  }
}
