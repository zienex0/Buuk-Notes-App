import 'package:buuk/models/note.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // I N I T I A L I Z E
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // list of notes
  List<Note> currentNotes = [];

  // C R E A T E
  Future<void> createNote(String noteTitle) async {
    // note obj
    final newNote = Note()
      ..title = noteTitle
      ..content = '';

    // save to db
    await isar.writeTxn(() => isar.notes.put(newNote));
    await fetchNotes();
  }

  // R E A D
  Future<void> fetchNotes() async {
    final fetchedNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchedNotes);
    notifyListeners();
  }

  // U P D A T E
  Future<void> updateNote(int id, String? title, String? content) async {
    await isar.writeTxn(() async {
      final note = await isar.notes.get(id);
      if (note != null) {
        if (title != null) note.title = title;
        if (content != null) note.content = content;
        note.updatedAt = DateTime.now();
        await isar.notes.put(note);
      }
    });
    await fetchNotes();
  }

  // D E L E T E
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async => await isar.notes.delete(id));
    fetchNotes();
  }
}
