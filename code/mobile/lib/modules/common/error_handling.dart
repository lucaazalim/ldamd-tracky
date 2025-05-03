import 'package:flutter/material.dart';

class ErrorHandlingPage extends StatelessWidget {
  const ErrorHandlingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.error, size: 100, color: Colors.red),
            SizedBox(height: 20),
            Text('An error occurred. Please try again later.',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}