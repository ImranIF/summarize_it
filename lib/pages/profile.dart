import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/sessionmanager.dart';
import 'package:summarize_it/components/textbox.dart';

import 'package:summarize_it/pages/graphql.dart';
import 'package:summarize_it/pages/rating.dart';
import 'package:summarize_it/screen/commentscreen.dart';
import 'package:summarize_it/screen/spashscreen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:timeago/timeago.dart' as timeago;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  void signUserOut() async {
    bool sessionLogOut = await SessionManager.logOut(context);

    if (sessionLogOut) {
      if (FirebaseAuth.instance.currentUser!.providerData[0].providerId ==
          'google.com') {
        await GoogleSignIn().signOut();
      } else if (FirebaseAuth
              .instance.currentUser!.providerData[0].providerId ==
          'facebook.com') {
        await FacebookAuth.instance.logOut();
      }
      await FirebaseAuth.instance.signOut();
      // make firebase email verified false so i must verify again
      Future.delayed(Duration(seconds: 2), () async {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    // final query = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(user.email)
    //     .snapshots();

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
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10, top: 20),
                        child: InkWell(
                            onTap: () {
                              getCurrentLocation().then((value) {
                                double lat = value.latitude;
                                double long = value.longitude;
                                print('Latitude: $lat, Longitude: $long');
                                openMap(lat.toString(), long.toString());
                              });
                            },
                            child: Ink(
                                padding: const EdgeInsets.only(
                                    top: 12.0,
                                    bottom: 12.0,
                                    left: 18.0,
                                    right: 18.0),
                                child: isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Locating",
                                            style: GoogleFonts.georama(
                                              fontSize: 20,
                                              color: const Color.fromARGB(
                                                  255, 35, 141, 123),
                                              // ,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.lightBlueAccent,
                                                strokeWidth: 3,
                                              )),
                                        ],
                                      )
                                    : Text(
                                        "Geo Location",
                                        style: GoogleFonts.georama(
                                          fontSize: 20,
                                          color: const Color.fromARGB(
                                              255, 35, 141, 123),
                                          // ,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                      ),
                      const Spacer(flex: 1),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AppRating())),
                                child: Ink(
                                  child: const Icon(Icons.stars_sharp,
                                      size: 25,
                                      color: Color.fromARGB(255, 55, 102, 84)),
                                )),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            margin: const EdgeInsets.only(right: 20, top: 20),
                            alignment: Alignment.topRight,
                            child: IconButton(
                                onPressed: signUserOut,
                                icon: const Icon(Icons.logout),
                                color: const Color.fromARGB(255, 55, 102, 84),
                                iconSize: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //get user data
                          // print(
                          //     'BAKA SPEAKING --------------------------------------- ${user.uid}');
                          final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          print(userData);

                          return ListView(
                            shrinkWrap: true,
                            // padding: const EdgeInsets.all(50),
                            children: [
                              const SizedBox(height: 50),
                              //profile
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    alignment: Alignment.center,
                                    child: WidgetZoom(
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
                                  ),
                                  // const SizedBox(width: 20),
                                ],
                              ),
                              // Icon(Icons.person, size: 60, color: Colors.white),
                              const SizedBox(height: 15),
                              //user email
                              //user detail

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userData['fullName'],
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 40, 94, 76),
                                        ),
                                      ),
                                      // IconButton(
                                      //     onPressed: () =>
                                      //         editField('Username'),
                                      //     icon: const Icon(Icons.settings))
                                    ],
                                  ),
                                  // TextBox(
                                  //   text: userData['fullName'],
                                  //   // sectionName: 'Username',
                                  //   onPressed: () => editField('Username'),
                                  // ),
                                  const SizedBox(height: 5),
                                  Text(user!.email!,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 39, 92, 70))),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const GraphQL())),
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: Ink(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 10.0,
                                              left: 16.0,
                                              right: 16.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24.0),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 111, 199, 158),
                                                  Color.fromARGB(
                                                      255, 101, 182, 144),
                                                  // Colors.lightBlueAccent[500]!,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'All User Info',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 100, 52, 34),
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Column(
                                children: [
                                  Image.asset('assets/line.png',
                                      width: MediaQuery.of(context).size.width *
                                          0.8),
                                ],
                              ),

                              // Padding(
                              //   padding: EdgeInsets.only(left: 25),
                              //   child: Text('My Details',
                              //       style: GoogleFonts.georama(
                              //         fontSize: 16,
                              //         color: const Color.fromARGB(
                              //             255, 35, 141, 123),
                              //         // ,
                              //         fontWeight: FontWeight.bold,
                              //       )),
                              // ),

                              //username

                              //bio
                              // customTextBox(
                              //   text: userData['bio'],
                              //   sectionName: 'Bio',
                              //   onPressed: () => editField('Bio'),
                              // ),

                              const SizedBox(height: 10),

                              //user posts count
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Text('My Posts',
                                        style: GoogleFonts.cormorantSc(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 28, 116, 101),
                                          // ,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
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
                          return Skeletonizer(
                              enabled: true,
                              child: ListView(shrinkWrap: true, children: [
                                const SizedBox(height: 50),
                                //profile
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      alignment: Alignment.center,
                                      child: const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            'assets/placeholder.png'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 100,
                                          child: const Text('Username'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      height: 20,
                                      width: 100,
                                      child: const Text('Email'),
                                    ),
                                  ],
                                ),
                              ]));
                        } else {
                          return const Center(child: Text('Error'));
                        }
                      }),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('email',
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser!.email)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final userPosts = snapshot.data!.docs;
                          return SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: userPosts.length,
                                itemBuilder: (context, index) {
                                  final postTime =
                                      Timestamp.fromMillisecondsSinceEpoch(
                                          userPosts[index]['timestamp'] as int);
                                  print(postTime);
                                  final formattedPostTime =
                                      timeago.format(postTime.toDate());
                                  bool isLiked = userPosts[index]['likes']
                                      .contains(user.email);
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 40, right: 40, top: 25),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 134, 207, 191),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                userPosts[index]['image'] !=
                                                        null
                                                    ? WidgetZoom(
                                                        heroAnimationTag:
                                                            'postImage',
                                                        zoomWidget:
                                                            Image.network(
                                                                userPosts[index]
                                                                    ['image'],
                                                                height: 100,
                                                                width: 100),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            userPosts[index]['image'] != null
                                                ? const SizedBox(width: 10)
                                                : const SizedBox(),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    userPosts[index]['title'],
                                                    style: GoogleFonts.georama(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              35,
                                                              141,
                                                              123),
                                                    ),
                                                  ),
                                                  Text(
                                                    userPosts[index]
                                                        ['description'],
                                                    style: GoogleFonts.georama(
                                                      fontSize: 10,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 25, 102, 89),
                                                    ),
                                                  ),
                                                  const Divider(
                                                    color: Color.fromARGB(
                                                        255, 66, 129, 121),
                                                    indent: 15,
                                                    endIndent: 15,
                                                  ),
                                                  Text(
                                                    formattedPostTime,
                                                    style: GoogleFonts.georama(
                                                      fontSize: 10,
                                                      color: Color.fromARGB(
                                                          255, 16, 66, 58),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // add like button and comment button icon
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    // print(isLiked);
                                                    // isLiked = !isLiked;
                                                    // print(isLiked);

                                                    if (userPosts[index]
                                                                ['likes']
                                                            .contains(
                                                                user.email) !=
                                                        true) {
                                                      print(
                                                          '---------------${userPosts[index]['likes']}');
                                                      userPosts[index]
                                                          .reference
                                                          .update({
                                                        'likes': FieldValue
                                                            .arrayUnion(
                                                                [user.email]),
                                                        'likeCount': FieldValue
                                                            .increment(1),
                                                      });
                                                    } else {
                                                      // userPosts[index]['likes']
                                                      //     .remove(user.email);
                                                      print(
                                                          'ehe---------------?${userPosts[index]['likes']}');
                                                      userPosts[index]
                                                          .reference
                                                          .update({
                                                        'likes': FieldValue
                                                            .arrayRemove(
                                                                [user.email]),
                                                        'likeCount': FieldValue
                                                            .increment(-1)
                                                      });
                                                      // FirebaseFirestore.instance
                                                      //     .collection('posts')
                                                      //     .doc('postId')
                                                      //     .update({
                                                      //   'likes':
                                                      //       FieldValue.arrayUnion(
                                                      //           [user.email]),
                                                      // });
                                                    }
                                                  });
                                                },
                                                icon: Icon(
                                                    Icons.favorite_rounded,
                                                    color: userPosts[index]
                                                                ['likes']
                                                            .contains(
                                                                user.email)
                                                        ? Colors.red
                                                        : Colors.black,
                                                    size: 10)),
                                            Text(userPosts[index]['likeCount']
                                                .toString()),
                                            IconButton(
                                                onPressed: () {
                                                  print(
                                                      '-----------------${userPosts[index]['postId']}');
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CommentScreen(
                                                                  postId: userPosts[
                                                                          index]
                                                                      ['postId']
                                                                  // post: userPosts[index],
                                                                  )));
                                                },
                                                icon: const Icon(
                                                  Icons.comment,
                                                  size: 10,
                                                )),
                                            const SizedBox(width: 10),
                                            Material(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    customBorder:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    onTap: () {
                                                      displayDeleteDialog(
                                                          context,
                                                          userPosts[index]);
                                                    },
                                                    child: Ink(
                                                      child: const Icon(
                                                        Icons
                                                            .delete_forever_rounded,
                                                        size: 15,
                                                        color: Color.fromARGB(
                                                            255, 35, 141, 123),
                                                      ),
                                                    )))
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                            //   return ListTile(
                            //     title: Text(userPosts[index]['title']),
                            //     subtitle:
                            //         Text(userPosts[index]['description']),
                            //     leading: userPosts[index]['image'] != null
                            //         ? Image.network(
                            //             userPosts[index]['image'])
                            //         : null,
                            //   );
                            // }),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Skeletonizer(
                            enabled: true,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 40, right: 40, top: 25),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 134, 207, 191),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        const Row(
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 100,
                                                  width: 100,
                                                  child:
                                                      Icon(Icons.abc_outlined),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                    width: 100,
                                                    child: Text('Title'),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    width: 100,
                                                    child: Text('Description'),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    width: 100,
                                                    child: Text('Time'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        // add like button and comment button icon
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.black,
                                                    size: 10)),
                                            const Text('0'),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.comment,
                                                  size: 10,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          );
                          // return const Center(
                          //     child: CircularProgressIndicator());
                        } else {
                          return const Center(child: Text('Error'));
                        }
                      }),
                  const SizedBox(height: 25),
                ],
              )),
            ),
          )),
    );
  }

  Future<Position> getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void toggleLike() {}

  Future<void> openMap(String latitude, String longitude) async {
    String googleURL =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await canLaunchUrlString(googleURL)
        ? await launchUrlString(googleURL)
        : throw "Could not launch $googleURL";
    setState(() {
      isLoading = false;
    });
  }

  Future<void> displayDeleteDialog(BuildContext context, dynamic post) async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Delete Post',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 31, 140, 155),
                    )),
                content:
                    const Text('Are you sure you want to delete this post?'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () async {
                        await post.reference.delete();
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ))
                ]));
  }
}
