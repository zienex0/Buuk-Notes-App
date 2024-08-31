import 'package:buuk/components/drawer_tile.dart';
import 'package:buuk/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_document,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  'Buuk Notes',
                  style: GoogleFonts.dmSerifText(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.inversePrimary),
                )
              ],
            ),
          ),

          // drawer tiles
          DrawerTile(
              title: 'Notes',
              leading: Icon(
                Icons.home_filled,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                // go back to the root page
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.of(context).pop();
              }),

          DrawerTile(
              title: 'Settings',
              leading: Icon(Icons.settings,
                  color: Theme.of(context).colorScheme.primary),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const SettingsPage(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
