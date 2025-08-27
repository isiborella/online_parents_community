import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:online_parents_community/home_page.dart';
import 'login_page.dart';
import 'screens/main_screen.dart';

late Client client; // Appwrite client globally

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite client
  client = Client()
    ..setEndpoint('https://nyc.cloud.appwrite.io/v1')
    ..setProject('68a714550022e0e26594')
    ..setSelfSigned(status: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parent Community',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF2193b0),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2193b0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF2193b0),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
