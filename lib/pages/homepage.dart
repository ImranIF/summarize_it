import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/components/custombutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                padding: const EdgeInsets.all(50),
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: CustomButton(
                        text: 'LOGOUT',
                        onPressed: signUserOut,
                        hpadding: 15,
                        wpadding: 15,
                        borderRadius: 15.0,
                        color: const Color.fromARGB(255, 16, 58, 40)),
                  )
                ],
              ),
            ),
          )),
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
}
