import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/components/theme_provider.dart';
import '../common/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  final AuthService _authService = AuthService();
  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text;

    final user = await _authService.login(username);

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user['id']);
      await prefs.setString('username', username);
      await prefs.setString('type', user['type']);

      if (user['type'] == 'CUSTOMER') {
        Navigator.pushReplacementNamed(
          context,
          '/customer/orders',
        );
      } else if (user['type'] == 'DRIVER') {
        Navigator.pushReplacementNamed(context, '/driver/pending-deliveries');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracky'),
        titleTextStyle: TextStyle(
            color: const Color(0xFFBFF205),
            fontSize: 20.0
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.brightness_2 : Icons.wb_sunny,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
        automaticallyImplyLeading: false,

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              style: TextStyle(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBFF205),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () => _login(context),
              child: const Text('Login', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
