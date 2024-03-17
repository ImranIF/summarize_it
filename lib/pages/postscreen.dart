import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:summarize_it/components/custombutton.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:summarize_it/pages/profile.dart';
import 'package:summarize_it/screen/homescreen.dart';
import 'package:widget_zoom/widget_zoom.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final isLiked = false;
  final List<String> likes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? imageLocalPath;
  late String imgUrl;
  XFile? file;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
              child: SingleChildScrollView(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(30),
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create Post',
                        style: GoogleFonts.cormorantSc().copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset('assets/line.png',
                        width: MediaQuery.of(context).size.width * 0.5),
                    const SizedBox(height: 15),
                    Text('Enter Title',
                        style: GoogleFonts.cormorant().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 35, 141, 123))),
                    const SizedBox(height: 15),
                    CustomTextFieldDescription(false,
                        controller: titleController,
                        maxLines: 1,
                        hintText: 'e.g: Impact of neural Knowledge Graphs ',
                        obscureText: false,
                        hasLabel: false,
                        hasPrefixIcon: false,
                        hasOnChanged: false),
                    const SizedBox(height: 15),
                    Text('Enter Description',
                        style: GoogleFonts.cormorant().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 35, 141, 123))),
                    const SizedBox(height: 15),
                    CustomTextFieldDescription(false,
                        controller: descriptionController,
                        maxLines: 6,
                        hintText: "e.g: The earth is nearing destruction",
                        obscureText: false,
                        hasLabel: false,
                        hasPrefixIcon: false,
                        hasOnChanged: false),
                    const SizedBox(height: 15),
                    Text('Attach Image (Optional)',
                        style: GoogleFonts.cormorant().copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 35, 141, 123))),
                    imageLocalPath == null
                        ? const Icon(
                            Icons.photo,
                            size: 60,
                          )
                        : WidgetZoom(
                            heroAnimationTag: 'postImage',
                            zoomWidget: Image.file(
                              File(imageLocalPath!),
                              height: 60,
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          icon: const Icon(Icons.photo_camera,
                              color: Color.fromARGB(255, 12, 87, 105)),
                          label: const Text('Capture',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 12, 87, 105))),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          icon: const Icon(Icons.photo_library_rounded,
                              color: Color.fromARGB(255, 12, 87, 105)),
                          label: const Text(
                            'Gallery',
                            style: TextStyle(
                                color: Color.fromARGB(255, 12, 87, 105)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Material(
                      borderRadius: BorderRadius.circular(24.0),
                      child: InkWell(
                        onTap: () => submitPost(context),
                        customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        child: Ink(
                          width: MediaQuery.of(context).size.width * 0.4,
                          padding: const EdgeInsets.only(
                              top: 12.0, bottom: 12.0, left: 18.0, right: 18.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 111, 199, 158),
                                  Color.fromARGB(255, 101, 182, 144),
                                  // Colors.lightBlueAccent[500]!,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )),
                          child: isLoading
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Submitting. Please wait...',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 100, 52, 34),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          strokeWidth: 3,
                                        ))
                                  ],
                                )
                              : const Center(
                                  child: Text(
                                    'Submit Post',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 100, 52, 34),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Future<void> submitPost(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    // insert image
    if (imageLocalPath != null) {
      final String imageName = 'image_${DateTime.now().millisecondsSinceEpoch}';
      const String imageDirectory = 'Posts/';
      final photoRef =
          FirebaseStorage.instance.ref().child('$imageDirectory$imageName');
      final uploadTask = photoRef.putFile(File(imageLocalPath!));
      final snapshot = await uploadTask.whenComplete(() => null);
      imgUrl = await snapshot.ref.getDownloadURL();
      print(imgUrl);
    }

    // get user
    final userEmail = FirebaseAuth.instance.currentUser?.email.toString();
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
    final data = query.docs[0].data();
    print('user: $data');

    // insert post
    Map<String, dynamic> postData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'image': imageLocalPath != null ? imgUrl : null,
      'userName': data['userName'],
      'email': userEmail,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'likeCount': 0,
      'likes': likes,
      'postId': '',
    };
    // To safely convert it back to DateTime
    // DateTime fetchedTime = DateTime.fromMillisecondsSinceEpoch(data['time']);

    final postRef =
        await FirebaseFirestore.instance.collection('posts').add(postData);
    await postRef.update({'postId': postRef.id});
    print(postRef.id);
    // print(FirebaseFirestore.instance
    //     .collection('posts')
    //     .where('email', isEqualTo: userEmail)
    //     .snapshots());

    // update user's postcount
    await FirebaseFirestore.instance.collection('users').doc(userEmail).update({
      'postCount': data['postCount'] + 1,
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post Submitted!', textAlign: TextAlign.center),
        content: const Text('You have successfully submitted your post!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
            child: const Text('Okay'),
          ),
        ],
      ),
    );

    // await Future.delayed(const Duration(seconds: 3));

    setState(() {
      isLoading = false;
    });
  }

  void getImage(ImageSource source) async {
    final imageFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    if (imageFile != null) {
      setState(() {
        imageLocalPath = imageFile.path;
        file = imageFile;
      });
    }
  }
}
