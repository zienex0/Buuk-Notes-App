import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {required this.title,
      required this.leading,
      required this.onTap,
      super.key});

  final String title;
  final Widget leading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}
