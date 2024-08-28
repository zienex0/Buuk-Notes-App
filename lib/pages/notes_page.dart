import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

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
                onPressed: () => createNote(textController.text),
                child: const Text('Create'),
              )
            ],
          );
        });
  }

  // create note
  void createNote(String noteTitle) {
    // TODO convert to note class
    // TODO save the note to database
    print(noteTitle);
  }

  // view note
  void readNote() {
    // TODO implement reading notes logic
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
