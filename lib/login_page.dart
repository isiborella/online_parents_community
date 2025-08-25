import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:online_parents_community/screens/main_screen.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Appwrite Client + Account
  final Client client = Client();
  late Account account;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint(
          'https://nyc.cloud.appwrite.io/v1',
        ) // e.g. http://localhost/v1 or https://cloud.appwrite.io/v1
        .setProject('68a714550022e0e26594')
        .setSelfSigned(status: true); // Replace with your project ID
    account = Account(client);
  }

  void loginUser() async {
    try {
      await account.createEmailPasswordSession(
        email: emailController.text,
        password: passwordController.text,
      );

      final context = this.context; // Store context locally
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.transparent,
                blurRadius: 3,
                spreadRadius: 2,
                offset: Offset(10, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(onPressed: loginUser, child: const Text("Login")),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
