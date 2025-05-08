import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/driver/screens/order_details_page.dart';
import 'package:provider/provider.dart';
import 'modules/customer/screens/orders.dart';
import 'theme_provider.dart';
import 'modules/customer/screens/order_details_page.dart';
import 'modules/common/screens/notifications_page.dart';
import 'modules/lobby/login_page.dart';
import 'modules/driver/screens/pending_orders_page.dart';

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
        '/': (context) => const LoginPage(),
        '/customer/orders': (context) => const OrdersPage(),
        '/customer/order/details': (context) => const OrderDetailsPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/driver/pending-deliveries': (context) => PendingOrdersScreen(),
        '/driver/order/details': (context) => OrderDetailsScreen()
      },
    );
  }
}
