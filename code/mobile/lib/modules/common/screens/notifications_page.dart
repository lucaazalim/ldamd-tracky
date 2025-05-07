import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme_provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final mockNotifications = [
      {'title': 'Order Shipped', 'message': 'Your order #12345 has been shipped.'},
      {'title': 'Order Delivered', 'message': 'Your order #67890 has been delivered.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications, color: Colors.orange),
            title: Text(notification['title']!,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                )),
            subtitle: Text(notification['message']!,
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                )),
          );
        },
      ),
    );
  }
}