import 'package:buuk/components/note_settings.dart';
import 'package:buuk/models/note.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final void Function() onEdit;
  final void Function() onDelete;

  const NoteTile(
      {required this.note,
      required this.onEdit,
      required this.onDelete,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: ListTile(
        title: Text(
          note.title,
          style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.inversePrimary),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showPopover(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  context: context,
                  bodyBuilder: (context) => NoteSettings(
                        onEdit: () => onEdit(),
                        onDelete: () => onDelete(),
                      ));
            },
          );
        }),
      ),
    );
  }
}
