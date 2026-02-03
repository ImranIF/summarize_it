import 'dart:async';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/models/usermodel.dart';
import 'package:summarize_it/models/textsummarizationmodel.dart';
import 'package:summarize_it/pages/aboutus.dart';
import 'package:summarize_it/pages/graphql.dart';
import 'package:summarize_it/pages/homepage.dart';
import 'package:summarize_it/pages/postlist.dart';
import 'package:summarize_it/pages/postscreen.dart';
import 'package:summarize_it/pages/profile.dart';
import 'package:summarize_it/pages/summarizer.dart';
import 'package:summarize_it/provider/userprovider.dart';
import 'package:summarize_it/screen/spashscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    UserProvider userProvider = Provider.of(context,
        listen:
            false); // restrict continuous listening of the value provider by the provider to false
    await userProvider?.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<UserProvider>(context)
        .userModel; // get the userModel from the provider using the context
    return Scaffold(
        body: pageOptions[selectedPage],
        bottomNavigationBar: ConvexAppBar.badge(
            {
              // 3: '10+', // badge value
            },
            backgroundColor: const Color.fromARGB(255, 60, 139, 136),
            style: TabStyle.reactCircle,
            items: const [
              TabItem(
                icon: Icons.person,
                title: 'Profile',
              ),
              TabItem(icon: Icons.summarize, title: 'Summarizer'),
              TabItem(icon: Icons.add, title: 'Create Post'),
              TabItem(icon: Icons.post_add, title: 'Post List'),
            ],
            onTap: (index) => setState(() {
                  print(
                      '----------------userModel: ${userModel}--------------------');
                  // Clear output text when switching pages
                  if (selectedPage != index) {
                    final model = Provider.of<TextSummarizationModel>(context,
                        listen: false);
                    model.setOutputText('');
                  }
                  selectedPage = index;
                })));
  }

  void signUserOut() async {
    // Clear output text on logout
    final model = Provider.of<TextSummarizationModel>(context, listen: false);
    model.setOutputText('');

    await GoogleSignIn.instance.signOut();
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }
}
