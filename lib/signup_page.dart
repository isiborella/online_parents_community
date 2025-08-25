import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Appwrite client + account
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
        .setSelfSigned(status: true); // replace with your Appwrite project ID
    account = Account(client);
  }

  void registerUser() async {
    try {
      await account.create(
        userId: ID.unique(), // generates a unique user ID
        email: emailController.text,
        password: passwordController.text,
      );

      // After signup, also create session (so they’re logged in immediately)
      await account.createEmailPasswordSession(
        email: emailController.text,
        password: passwordController.text,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerUser,
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
