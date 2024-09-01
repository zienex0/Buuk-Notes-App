import 'package:buuk/models/note.dart';
import 'package:buuk/models/note_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NoteContentPage extends StatefulWidget {
  const NoteContentPage({required this.note, super.key});
  final Note note;

  @override
  State<NoteContentPage> createState() => _NoteContentPageState();
}

class _NoteContentPageState extends State<NoteContentPage> {
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.note.content);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveNote(BuildContext context) {
    _focusNode.unfocus();
    context.read<NoteDatabase>().updateNote(
          widget.note.id,
          widget.note.title,
          _textEditingController.text,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // appbar with save and back buttons
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          // save button
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () => _saveNote(context),
                icon: const Icon(
                  Icons.check_rounded,
                  size: 30,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.title,
              style: GoogleFonts.dmSerifText(fontSize: 32),
            ),
            Expanded(
              child: TextField(
                controller: _textEditingController,
                focusNode: _focusNode,
                autofocus: false,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                    hintText: 'Start typing your note...',
                    border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
