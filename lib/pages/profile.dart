import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/textbox.dart';
import 'package:summarize_it/screen/spashscreen.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:widget_zoom/widget_zoom.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
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
                      Container(
                        margin: const EdgeInsets.only(right: 20, top: 20),
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: signUserOut,
                            icon: Icon(Icons.logout),
                            color: Colors.black,
                            iconSize: 30),
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 10),
                                    alignment: Alignment.topLeft,
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            userData['fullName'],
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 40, 94, 76),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () =>
                                                  editField('Username'),
                                              icon: const Icon(Icons.settings))
                                        ],
                                      ),
                                      // TextBox(
                                      //   text: userData['fullName'],
                                      //   // sectionName: 'Username',
                                      //   onPressed: () => editField('Username'),
                                      // ),
                                      Text(user!.email!,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 39, 92, 70))),
                                    ],
                                  ),
                                ],
                              ),
                              // Icon(Icons.person, size: 60, color: Colors.white),
                              const SizedBox(height: 20),
                              //user email
                              //user detail

                              Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text('My Details',
                                    style: GoogleFonts.georama(
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          255, 35, 141, 123),
                                      // ,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),

                              //username

                              //bio
                              customTextBox(
                                text: userData['bio'],
                                sectionName: 'Bio',
                                onPressed: () => editField('Bio'),
                              ),

                              const SizedBox(height: 20),

                              //user posts count
                              Padding(
                                padding: EdgeInsets.only(left: 25),
                                child: Text('My Posts',
                                    style: GoogleFonts.georama(
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          255, 35, 141, 123),
                                      // ,
                                      fontWeight: FontWeight.bold,
                                    )),
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
}
