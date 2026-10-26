import 'package:flutter/material.dart';

import 'database/session.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/register_screen.dart';
import 'utils/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Session.restore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: kPrimary,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimary,
          foregroundColor: kOnPrimary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimary,
          foregroundColor: kOnPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimary,
            foregroundColor: kOnPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: kPrimary[800]),
        ),
      ),

      // MENGGUNAKAN NAMED ROUTES
      initialRoute: '/',
      routes: {
        // Jika belum login, rute '/' menampilkan halaman Login
        '/': (context) =>
            Session.user == null ? const LoginScreen() : const MainScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/add': (context) => const AddTransactionScreen(),
      },
    );
  }
}
