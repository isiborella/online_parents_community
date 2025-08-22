import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:online_parents_community/home_page.dart';
import 'package:online_parents_community/login_page.dart';
import 'screens/main_screen.dart'; // Import your new MainScreen

late Client client; // Appwrite client will be available globally

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Appwrite client
  client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Appwrite endpoint
    ..setProject(
      '68a714550022e0e26594',
    ).setSelfSigned(status: true); // Your Appwrite project ID

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parent Community',
      theme: ThemeData(primarySwatch: Colors.blue),
      // You can decide whether HomePage or LoginPage should be the first screen
      home: LoginPage(),
      routes: {
        '/main': (context) => MainScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
