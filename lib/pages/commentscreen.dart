import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:summarize_it/models/usermodel.dart';
import 'package:summarize_it/provider/userprovider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final User user;
  late final UserModel? userModel =
      Provider.of<UserProvider>(context).userModel;
  late String userImageURL;
  TextEditingController commentController = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments =
      FirebaseFirestore.instance.collection('comments').snapshots();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // user = FirebaseAuth.instance.currentUser!;
    setState(() {
      userImageURL = userModel!.imageURL;
    });
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
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Comments',
                            style: GoogleFonts.cormorantSc().copyWith(
                                fontSize: 30,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 52, 94, 74))),
                      ],
                    ),
                  ),
                  // margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: userImageURL == null
                              ? CircleAvatar(
                                  radius: 20,
                                  backgroundImage: Image.asset(
                                    'assets/placeholder.png',
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ).image,
                                )
                              : CircleAvatar(
                                  radius: 20,
                                  backgroundImage: Image.network(
                                    userModel!.imageURL,
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.cover,
                                  ).image,
                                ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: CustomTextFieldDescription(false,
                              controller: commentController,
                              maxLines: 1,
                              hintText: 'Add a comment...',
                              obscureText: false,
                              hasLabel: false,
                              hasPrefixIcon: false,
                              hasOnChanged: false),
                        ),
                        // Container(
                        //   width: 300.0,
                        //   height: 50.0,
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: 'Add a comment',
                        //       hintStyle: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color.fromARGB(255, 52, 94, 74),
                          ),
                          onPressed: () {
                            postComment();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('comments')
                          .where('postId', isEqualTo: widget.postId)
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        print(
                            '-----------------snapshot: ${snapshot.connectionState}-----------------');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                'assets/Loading-anim.json',
                                width: 50,
                                height: 55,
                                frameRate: const FrameRate(60),
                                animate: true,
                              ),
                            ],
                          );
                        } else if (snapshot.data == null ||
                            snapshot.data!.docs.isEmpty) {
                          return const Text('No comments');
                        } else if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        } else {
                          final documents = snapshot.data!.docs;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                print(
                                    'Time of the comment: ------------${documents[index]['timestamp'].millisecondsSinceEpoch}-----------------');
                                final commentTime =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        documents[index]['timestamp']
                                            .millisecondsSinceEpoch);
                                final formattedCommentTime =
                                    timeago.format(commentTime);
                                return Container(
                                  margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
                                    bottom: 10,
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, top: 10, bottom: 10),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 120, 187, 181),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: Image.network(
                                            documents[index]['imageURL'],
                                            height: 20,
                                            width: 20,
                                            fit: BoxFit.cover,
                                          ).image,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              documents[index]['comment'],
                                              style: GoogleFonts.cormorant()
                                                  .copyWith(
                                                      fontSize: 12,
                                                      letterSpacing: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              35,
                                                              141,
                                                              123)),
                                            ),
                                            // line divider
                                            const Divider(
                                              color: Color.fromARGB(
                                                  255, 107, 207, 194),
                                              indent: 15,
                                              endIndent: 15,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '@${documents[index]['username']}',
                                                  style: GoogleFonts
                                                          .cormorantSc()
                                                      .copyWith(
                                                          fontSize: 12,
                                                          // letterSpacing: 1.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(255, 27,
                                                              110, 97)),
                                                ),
                                                const Spacer(),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  child: Row(
                                                    children: [
                                                      Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          customBorder:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                          onTap: () {},
                                                          child: const Icon(
                                                            Icons
                                                                .thumb_up_sharp,
                                                            size: 15,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    35,
                                                                    141,
                                                                    123),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      if (documents[index]
                                                              ['username'] ==
                                                          userModel!.userName)
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                      if (documents[index][
                                                              'username'] ==
                                                          userModel!.userName)
                                                        Material(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                                customBorder: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                onTap: () {
                                                                  // confirm for deletion
                                                                  displayDeleteDialog(
                                                                      documents[
                                                                          index]);
                                                                },
                                                                child: Ink(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete_forever_rounded,
                                                                    size: 15,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            35,
                                                                            141,
                                                                            123),
                                                                  ),
                                                                )))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              formattedCommentTime,
                                              style: GoogleFonts.cormorant()
                                                  .copyWith(
                                                      fontSize: 10,
                                                      // letterSpacing: 1.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              35,
                                                              141,
                                                              123)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ])))));
  }

  Future<void> displayDeleteDialog(dynamic document) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text(
            'Delete your comment?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 31, 140, 155)),
          ),
          content: const Text("Are you sure you want to delete?"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                )),
            ElevatedButton(
                onPressed: () {
                  document.reference.delete();
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red.shade700),
                )),
          ]),
    );
  }

  Future<void> postComment() async {
    if (commentController.text.isNotEmpty) {
      setState(() async {
        // final User user =
        //     Provider.of<UserProvider>(context, listen: false).getUser;
        // final UserModel userModel = await UserModel.getUserData(user.email!);
        print(
            '----------------userModel: ${userModel!.email}--------------------');
        Map<String, dynamic> commentData = {
          'commentId': '',
          'postId': widget.postId,
          'comment': commentController.text,
          'username': userModel!.userName,
          'imageURL': userModel!.imageURL,
          'timestamp': DateTime.now(),
        };
        commentController.clear();
        final commentRef = await FirebaseFirestore.instance
            .collection('comments')
            .add(commentData);
        await commentRef.update({
          'commentId': commentRef.id,
        });
      });
    }
  }
  // if (commentController.text.isNotEmpty) {
  //                             FirebaseFirestore.instance
  //                                 .collection('comments')
  //                                 .add({
  //                               'postId': widget.postId,
  //                               'comment': commentController.text,
  //                               'username': user.displayName,
  //                               'photoURL': user.photoURL,
  //                               'timestamp': FieldValue.serverTimestamp(),
  //                             });
  //                             commentController.clear();
  //                           }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CommentScreen extends StatefulWidget {
//   final String postId;

//   CommentScreen({required this.postId});

//   @override
//   _CommentScreenState createState() => _CommentScreenState();
// }

// class _CommentScreenState extends State<CommentScreen> {
//   final TextEditingController _commentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Comments'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('comments')
//                   .where('postId', isEqualTo: widget.postId)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var comment = snapshot.data!.docs[index];
//                       return ListTile(
//                         title: Text(comment['text']),
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your comment',
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     String commentText = _commentController.text.trim();
//                     if (commentText.isNotEmpty) {
//                       FirebaseFirestore.instance.collection('comments').add({
//                         'postId': widget.postId,
//                         'text': commentText,
//                       });
//                       _commentController.clear();
//                     }
//                   },
//                   child: Text('Add Comment'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
