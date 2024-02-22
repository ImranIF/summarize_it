import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/pages/homepage.dart';
import 'package:summarize_it/pages/postlist.dart';
import 'package:summarize_it/pages/postscreen.dart';
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
    const Profile(),
    Summarizer(),
    const PostScreen(),
    const PostList(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: ConvexAppBar.badge(
            const {
              3: '10+', // badge value
            },
            backgroundColor: const Color.fromARGB(255, 60, 139, 136),
            items: const [
              TabItem(icon: Icons.person, title: 'Profile'),
              TabItem(icon: Icons.summarize, title: 'Summarizer'),
              TabItem(icon: Icons.add, title: 'Create Post'),
              TabItem(icon: Icons.post_add, title: 'Post List'),
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
