import 'package:flutter/material.dart';
import 'package:mobile/modules/common/services/user_service.dart';
import 'package:provider/provider.dart';

import '../common/components/theme_provider.dart';
import '../common/data/enum/user_type.dart';
import '../common/data/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _selectedType = 'CUSTOMER';

  final UserService _userService = UserService();

  Future<void> _register(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text;
    final String type = _selectedType;

    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      final newUser = User(
        name: username,
        email: email,
        password: password,
        type: UserType.fromString(type),
        id: '',
      );

      final user = await _userService.registerUser(newUser);

      print('user: $user');

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${user.name}! Your account has been created successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Redireciona após breve atraso para permitir leitura da mensagem
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again later.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      String errorMessage = 'An unexpected error occurred.';
      if (e.toString().contains('email')) {
        errorMessage = 'This email is already in use.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracky'),
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 5, 242, 112), // seta verde
        ),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 5, 242, 112),
            fontSize: 20.0
        ),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark ? Icons.brightness_2 : Icons.wb_sunny,
            ),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
                  'Sign up',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    
                  ),
                  items: const [
                    DropdownMenuItem(value: 'CUSTOMER', child: Text('Customer')),
                    DropdownMenuItem(value: 'DRIVER', child: Text('Driver')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _register(context),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color.fromARGB(255, 5, 242, 112),
                        ),
                        icon: const Icon(Icons.check, color: Colors.black),
                        label: const Text('Confirm', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _goToLogin,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color.fromARGB(255, 5, 242, 112), width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: const Color.fromARGB(255, 5, 242, 112),
                        ),
                        icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 5, 242, 112)),
                        label: const Text('Back', style: TextStyle(color: Color.fromARGB(255, 5, 242, 112))),
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
