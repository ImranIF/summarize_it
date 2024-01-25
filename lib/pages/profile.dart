import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/screen/spashscreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 162, 236, 169),
              Color.fromARGB(255, 92, 175, 170),
              // Color.fromARGB(10, 52, 59, 53),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                // padding: const EdgeInsets.all(50),
                children: [
                  ElevatedButton(
                      onPressed: signUserOut,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 37, 82, 59),
                            Color.fromARGB(255, 37, 82, 59)
                          ])),
                          child: const Row(
                            children: [
                              Icon(Icons.logout, color: Colors.white, size: 20),
                              Text('Logout',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
