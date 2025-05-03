import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_provider.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final mockOrderHistory = [
      {'orderId': '12345', 'date': '2025-05-01', 'status': 'Delivered'},
      {'orderId': '67890', 'date': '2025-04-28', 'status': 'Delivered'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockOrderHistory.length,
        itemBuilder: (context, index) {
          final order = mockOrderHistory[index];
          return ListTile(
            leading: Icon(Icons.history, color: themeProvider.isDarkMode ? Colors.white : Colors.black,),
            title: Text('Order ID: ${order['orderId']}',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                )),
            subtitle: Text('Date: ${order['date']}\nStatus: ${order['status']}',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                )),
          );
        },
      ),
    );
  }
}