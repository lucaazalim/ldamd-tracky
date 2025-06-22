import 'package:flutter/material.dart';
import 'package:mobile/modules/common/data/enum/user_type.dart';
import 'package:mobile/modules/common/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/components/theme_provider.dart';
import '../common/services/fcm_service.dart';
import '../../modules/common/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService();
  Future<void> _login(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final user = await _userService.login(email, password);

    if (user != null) {
      await FCMService().initialize();
      await FCMService().updateTokenOnLogin(
        userId: user.id,
        dio: DioClient().dio,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', user.id);
      await prefs.setString('email', email);
      await prefs.setString('type', user.type.toJson());

      if (user.type == UserType.customer) {
        Navigator.pushReplacementNamed(
          context,
          '/customer/orders',
        );
      } else if (user.type == UserType.driver) {
        Navigator.pushReplacementNamed(context, '/driver/pending-deliveries');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found or invalid credentials.')),
      );
    }
  }

  void _goToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracky'),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
        titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 5, 242, 112),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(
                    color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () => _login(context),
                        icon: const Icon(Icons.login, color: Colors.black),
                        label: const Text('Login', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color.fromARGB(255, 5, 242, 112), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          foregroundColor: const Color.fromARGB(255, 5, 242, 112),
                        ),
                        onPressed: () => _goToRegister(),
                        icon: const Icon(Icons.person_add, color: Color.fromARGB(255, 5, 242, 112)),
                        label: const Text('Register', style: TextStyle(color: Color.fromARGB(255, 5, 242, 112))),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
