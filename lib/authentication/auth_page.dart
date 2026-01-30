import 'package:flutter/material.dart';
import 'package:summarize_it/authentication/loginpage.dart';
import 'package:summarize_it/screen/homescreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<AuthState>(
        stream: Supabase.instance.client.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final session = snapshot.hasData ? snapshot.data!.session : null;
          
          if (session != null) {
            // User is authenticated
            return const HomeScreen();
          } else {
            // User is not authenticated
            return const LoginPage();
          }
        },
      ),
    );
  }
}
