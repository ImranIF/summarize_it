import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/textbox.dart';
import 'package:summarize_it/screen/spashscreen.dart';
import 'package:widget_zoom/widget_zoom.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void signUserOut() async {
    // print('---------------------------${user!.email}');
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  Future<void> editField(String field) async {
    // return
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final query = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .snapshots();

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
            ),
          ),
          child: SafeArea(
            maintainBottomViewPadding: true,
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20, top: 20),
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: signUserOut,
                        icon: Icon(Icons.logout),
                        color: Colors.black,
                        iconSize: 30),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //get user data
                          print(
                              'BAKA SPEAKING --------------------------------------- ${user.uid}');
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          print(userData);

                          return ListView(
                            shrinkWrap: true,
                            // padding: const EdgeInsets.all(50),
                            children: [
                              const SizedBox(height: 50),
                              //profile
                              WidgetZoom(
                                  heroAnimationTag: 'profile',
                                  zoomWidget: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: Image.network(
                                      userData['imageURL'],
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ).image,
                                  )),
                              // Icon(Icons.person, size: 60, color: Colors.white),
                              const SizedBox(height: 20),
                              //user email
                              Text(user!.email!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 35, 137, 141))),

                              //user detail

                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text('My Details',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 35, 137, 141))),
                              ),

                              //username
                              TextBox(
                                text: userData['fullName'],
                                sectionName: 'Username',
                                onPressed: () => editField('Username'),
                              ),

                              //bio
                              TextBox(
                                text: userData['bio'],
                                sectionName: 'Bio',
                                onPressed: () => editField('Bio'),
                              ),

                              const SizedBox(height: 20),

                              //user posts count
                              const Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text('My Posts',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            Color.fromARGB(255, 35, 137, 141))),
                              ),

                              //user posts
                              // ListView.builder(
                              //     shrinkWrap: true,
                              //     itemCount: userData['posts'].length,
                              //     itemBuilder: (context, index) {
                              //       return TextBox(
                              //         text: userData['posts'][index],
                              //         sectionName: 'Post ${index + 1}',
                              //         onPressed: () =>
                              //             editField('Post ${index + 1}'),
                              //       );
                              //     }),

                              //logout button
                            ],
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(child: Text('Error'));
                        }
                      }),
                ],
              )),
            ),
          )),
    );
  }
}
