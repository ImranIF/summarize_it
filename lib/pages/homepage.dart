import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/pages/profile.dart';
import 'package:summarize_it/screen/spashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = Supabase.instance.client.auth.currentUser;

  void signUserOut() async {
    print('---------------------------${user?.email}');
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

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
                padding: const EdgeInsets.all(50),
                children: [
                  IconButton(
                      onPressed: signUserOut,
                      icon: Icon(Icons.logout),
                      color: Colors.black,
                      iconSize: 30),
                ],
              ),
            ),
          )),
    );
  }
}
