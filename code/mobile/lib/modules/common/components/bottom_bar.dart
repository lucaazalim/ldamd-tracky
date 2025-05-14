import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A bottom navigation bar for the application.
///
/// This widget dynamically adjusts its items and routes based on the user type (CUSTOMER or DRIVER).
class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({super.key, required this.currentIndex});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String _userType = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    _userType = prefs.getString('type') ??
        'CUSTOMER'; // Default to CUSTOMER if not found
  }

  void _onItemTapped(BuildContext context, int index) {
    List<String> routes = [];
    if (_userType == 'CUSTOMER') {
      routes = [
        '/customer/orders',
        '/customer/notifications',
        '/preferences',
        '/',
      ];
    } else {
      routes = [
        '/driver/pending-deliveries',
        '/preferences',
        '/',
      ];
    }

    if (index != widget.currentIndex) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserType(), // Load user type before building
      builder: (context, snapshot) {
        // Use a switch statement para construir o widget apropriado
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator(); // Or a loading indicator
          default:
            return BottomNavigationBar(
              currentIndex: widget.currentIndex,
              onTap: (index) => _onItemTapped(context, index),
              type: BottomNavigationBarType.fixed,
              items: _getBottomNavItems(),
            );
        }
      },
    );
  }

  List<BottomNavigationBarItem> _getBottomNavItems() {
    if (_userType == 'CUSTOMER') {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Preferences',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Preferences',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Logout',
        ),
      ];
    }
  }
}
