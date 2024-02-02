// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:summarize_it/components/custombutton.dart';
// import 'package:summarize_it/components/textbox.dart';
// import 'package:summarize_it/screen/spashscreen.dart';
// import 'package:widget_zoom/widget_zoom.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final user = FirebaseAuth.instance.currentUser;
//   void signUserOut() async {
//     // print('---------------------------${user!.email}');
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => const SplashScreen()));
//   }

//   Future<void> editField(String field) async {
//     // return
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.email)
//         .snapshots();

//     @override
//     void initState() {
//       super.initState();

//       if (user != null) {
//         print('NOT NULL --------------------');
//       }
//     }

//     return Scaffold(
//       body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: const BoxDecoration(
//               gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 162, 236, 169),
//               Color.fromARGB(255, 92, 175, 170),
//               // Color.fromARGB(10, 52, 59, 53),
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           )),
//           child: SafeArea(
//             maintainBottomViewPadding: true,
//             child: Center(
//                 child: StreamBuilder<DocumentSnapshot>(
//                     stream: query,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         //get user data
//                         final userData = snapshot.data!.data();

//                         return ListView(
//                           shrinkWrap: true,
//                           // padding: const EdgeInsets.all(50),
//                           children: [
//                             const SizedBox(height: 50),
//                             //profile
//                             WidgetZoom(
//                                 heroAnimationTag: 'profile',
//                                 zoomWidget: Image.network(userData['imageURL'],
//                                     height: 100, width: 100)),
//                             // Icon(Icons.person, size: 60, color: Colors.white),
//                             const SizedBox(height: 20),
//                             //user email
//                             Text(user!.email!,
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Color.fromARGB(255, 35, 137, 141))),

//                             //user detail

//                             const Padding(
//                               padding: EdgeInsets.only(left: 25),
//                               child: Text('My Details',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color:
//                                           Color.fromARGB(255, 35, 137, 141))),
//                             ),

//                             //username
//                             TextBox(
//                               text: userData['fullname'],
//                               sectionName: 'Username',
//                               onPressed: () => editField('Username'),
//                             ),

//                             //bio
//                             TextBox(
//                               text: userData['bio'],
//                               sectionName: 'Bio',
//                               onPressed: () => editField('Bio'),
//                             ),

//                             const SizedBox(height: 20),

//                             const Padding(
//                               padding: EdgeInsets.only(left: 25),
//                               child: Text('My Posts',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color:
//                                           Color.fromARGB(255, 35, 137, 141))),
//                             ),

//                             //user posts

//                             //logout button
//                             IconButton(
//                                 onPressed: signUserOut,
//                                 icon: Icon(Icons.logout),
//                                 color: Colors.black,
//                                 iconSize: 30),
//                           ],
//                         );
//                       } else if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       } else {
//                         return const Center(child: Text('Error'));
//                       }
//                     })),
//           )),
//     );
//   }
// }
