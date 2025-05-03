import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme_provider.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final mockTrackingData = [
      {'orderId': '12345', 'status': 'In Transit', 'location': 'Warehouse A'},
      {'orderId': '67890', 'status': 'Out for Delivery', 'location': 'City Center'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockTrackingData.length,
        itemBuilder: (context, index) {
          final data = mockTrackingData[index];
          return ListTile(
            leading: Icon(Icons.local_shipping, color: themeProvider.isDarkMode ? Colors.white : Colors.black,),
            title: Text('Order ID: ${data['orderId']}',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                )),
            subtitle: Text('Status: ${data['status']}\nLocation: ${data['location']}',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white70 : Colors.black54,
                )),
          );
        },
      ),
    );
  }
}