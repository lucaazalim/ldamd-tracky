import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/modules/driver/screens/order_details_page.dart';
import 'package:mobile/modules/driver/screens/update_order_status_page.dart';
import 'package:provider/provider.dart';
import 'modules/common/screens/shared_preferences.dart';
import 'modules/customer/screens/orders_page.dart';
import 'modules/common/components/theme_provider.dart';
import 'modules/customer/screens/order_details_page.dart';
import 'modules/customer/screens/notifications_page.dart';
import 'modules/lobby/login_page.dart';
import 'modules/driver/screens/orders_page.dart';
import 'modules/customer/screens/order_form_page.dart';
import 'package:mobile/modules/common/services/user_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService.setAuthTokenFromPrefs();
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
        '/preferences': (context) => const PreferencesPage(),
        '/customer/orders': (context) => const OrdersPage(),
        '/customer/order/details': (context) => const OrderDetailsPage(),
        '/customer/order/form': (context) => const OrderFormPage(), 
        '/customer/notifications': (context) => const NotificationsPage(),
        '/driver/pending-deliveries': (context) => PendingOrdersScreen(),
        '/driver/order/details': (context) => OrderDetailsScreen(),
        '/driver/order/update-status': (context) => UpdateOrderStatusPage()
      },
    );
  }
}
