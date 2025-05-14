import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/components/theme_provider.dart';
import '../../common/components/bottom_bar.dart';

/// A page that displays a list of notifications for the user.
///
/// Notifications include updates about orders, such as shipping and delivery statuses.
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
      body: ListView.builder(
        itemCount: mockNotifications.length,
        itemBuilder: (context, index) {
          final notification = mockNotifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.orange),
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
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}