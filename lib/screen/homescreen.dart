import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/pages/homepage.dart';
import 'package:summarize_it/pages/profile.dart';
import 'package:summarize_it/pages/summarizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  List pageOptions = [
    const HomePage(),
    Summarizer(),
    const HomePage(),
    const Profile(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: ConvexAppBar.badge(
            const {
              2: '10+', // badge value
            },
            backgroundColor: const Color.fromARGB(255, 60, 139, 136),
            items: const [
              TabItem(icon: Icons.home, title: 'Home'),
              TabItem(icon: Icons.add, title: 'Summarizer'),
              TabItem(icon: Icons.post_add, title: 'Post List'),
              TabItem(icon: Icons.person, title: 'Profile'),
            ],
            onTap: (index) => setState(() {
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => const Center(
                  //     child: CircularProgressIndicator(),
                  //   ),
                  // );
                  // Navigator.pop(context);
                  selectedPage = index;
                })));
  }
}
