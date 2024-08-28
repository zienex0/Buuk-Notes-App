import 'package:buuk/models/note_database.dart';
import 'package:buuk/pages/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize notes database
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NoteDatabase(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotesPage(),
    );
  }
}
