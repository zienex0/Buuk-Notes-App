import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  final void Function() onEdit;
  final void Function() onDelete;

  const NoteSettings({required this.onEdit, required this.onDelete, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // edit button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
            child: const Text('Edit'),
          ),

          // delete button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
