import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:summarize_it/authentication/loginpage.dart';
import 'package:summarize_it/pages/homepage.dart';
import 'package:summarize_it/screen/homescreen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // if snapshot has data, then user is already logged in
          return const HomeScreen();
        } else {
          // if snapshot has no data, then user is not logged in
          return const LoginPage();
        }
      },
    ));
  }
}
