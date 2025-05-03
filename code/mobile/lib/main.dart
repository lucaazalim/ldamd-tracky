import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'modules/client/tracking_page.dart';
import 'modules/client/order_history_page.dart';
import 'modules/client/notifications_page.dart';
import 'modules/common/login_page.dart';
import 'modules/common/settings_page.dart';
import 'modules/driver/screens/pending_deliveries_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: const Color(0xFF060826),
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Tracky',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkMode
          ? ThemeData.dark()
          : ThemeData.light().copyWith(
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
              ),
            ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PendingDeliveriesPage(),
        '/tracking': (context) => const TrackingPage(),
        '/order-history': (context) => const OrderHistoryPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/settings': (context) => const SettingsPage(),
        '/welcome': (context) => PendingDeliveriesScreen()
      },
    );
  }
}
