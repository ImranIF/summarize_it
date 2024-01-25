import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/pages/homepage.dart';
import 'package:summarize_it/pages/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;
  List pageOptions = const [
    HomePage(),
    HomePage(),
    HomePage(),
    Profile(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: ConvexAppBar.badge({
          2: '10+'
        },
            items: [
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
