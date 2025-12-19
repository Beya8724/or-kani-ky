// main.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://your-supabase-url.supabase.co', // <-- Replace with your Supabase URL
    anonKey: 'your-anon-key',                     // <-- Replace with your Supabase anon key
    authFlowType: AuthFlowType.pkce,
  );

  runApp(const ProviderScope(child: MyApp())); // Added ProviderScope for Riverpod
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe System Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userEmail.isEmpty
                  ? 'No user logged in'
                  : 'Logged in as: $userEmail',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final response = await supabase.auth.signInWithOtp(
                    email: 'test@example.com', // <-- Replace with your test email
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(response.error?.message ??
                            'OTP sent to email')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              child: const Text('Sign In with OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
