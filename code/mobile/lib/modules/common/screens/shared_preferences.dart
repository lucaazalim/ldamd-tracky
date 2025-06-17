import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/theme_provider.dart';
import '../../common/components/bottom_bar.dart';

/// A page for displaying and managing user preferences.
///
/// This page shows the email, user type, and allows toggling the theme mode.
class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String _email = '';
  String _userType = '';
  int _bottomNavIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('email') ?? 'No email found';
      _userType = prefs.getString('type') ?? 'Unknown user type';
      _bottomNavIndex = _userType == 'CUSTOMER' ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.black,
        title: const Text('Preferences'),
        titleTextStyle: const TextStyle(color: Color.fromARGB(255, 5, 242, 112),fontSize: 24.0,),
         bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Container(
            color: Colors.black,
            height: 8,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Theme mode', style: TextStyle(fontSize: 18)),
                IconButton(
                  icon: Icon(
                    themeProvider.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny,
                  ),
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Email: $_email', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Text('User type: ${(_userType).toLowerCase()}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _bottomNavIndex), // Use dynamic index
    );
  }
}

