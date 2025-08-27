import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
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
      home: const LoginPage(),
      routes: {
        '/main': (context) => const MainScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
