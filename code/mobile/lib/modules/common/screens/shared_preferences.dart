import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme_provider.dart';
import '../../common/components/bottom_bar.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String _username = '';
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
      _username = prefs.getString('username') ?? 'No username found';
      _userType = prefs.getString('type') ?? 'Unknown user type';
      _bottomNavIndex = _userType == 'CUSTOMER' ? 2 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        titleTextStyle: const TextStyle(color: Color(0xFFBFF205), fontSize: 20.0),
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
            Text('Username: $_username', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            Text('User type: ${(_userType).toLowerCase()}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: _bottomNavIndex), // Use dynamic index
    );
  }
}

