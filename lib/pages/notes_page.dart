import 'package:buuk/components/drawer.dart';
import 'package:buuk/models/note.dart';
import 'package:buuk/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:buuk/components/note_tile.dart';

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
            backgroundColor: Theme.of(context).colorScheme.surface,
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
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: TextField(
              controller: textController,
              style: GoogleFonts.dmSerifText(fontSize: 16),
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

  void showDeleteNoteDialog(BuildContext context, Note note) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            content: Text(
              'Are you sure you want to delete "${note.title}"?',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  await deleteNote(context, note.id);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
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
        surfaceTintColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      // drawer
      drawer: const MyDrawer(),

      // add notes button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.secondary,
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
                  fontSize: 55,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          // horizontal line
          Container(
            height: 2,
            width: double.infinity,
            margin: const EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(5)),
          ),

          // display notes in list view
          Expanded(
            child: ListView.builder(
                itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  final note = currentNotes[index];
                  return NoteTile(
                    note: note,
                    onEdit: () => showUpdateNoteDialog(context, note),
                    onDelete: () => showDeleteNoteDialog(context, note),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
