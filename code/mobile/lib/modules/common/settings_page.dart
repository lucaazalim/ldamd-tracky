import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme Mode'),
            trailing: IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: themeProvider.isDarkMode ? const Color(0xFFBFF205) : Colors.grey,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
          ListTile(
            title: const Text('Notification Preferences'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}