import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => PostListState();
}

class PostListState extends State<PostList> {
  final searchController = TextEditingController();
  Stream<QuerySnapshot> streamQuery = FirebaseFirestore.instance
      .collection('posts')
      .orderBy('timestamp', descending: true)
      .snapshots();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        String searchText = searchController.text;
        if (searchText.isEmpty) {
          // do nothing
          streamQuery = FirebaseFirestore.instance
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .snapshots();
        } else {
          // search for posts
          streamQuery = FirebaseFirestore.instance
              .collection('posts')
              .where('title', isGreaterThanOrEqualTo: searchText.trim())
              .where('title', isLessThan: '${searchText.trim()}z')
              // .orderBy('timestamp', descending: true)
              .snapshots();

          // FirebaseFirestore.instance.collection('posts').where('title', isGreaterThanOrEqualTo: searchText).snapshots();
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  children: [
                    // search bar
                    // query snapshot
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: streamQuery
                            as Stream<QuerySnapshot<Map<String, dynamic>>>,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var userPosts = snapshot.data!.docs;
                            return SingleChildScrollView(
                                child: Column(
                              children: [
                                // search bar
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 25),
                                  child: CustomTextFieldDescription(false,
                                      controller: searchController,
                                      maxLines: 1,
                                      hintText: 'Search',
                                      obscureText: false,
                                      hasLabel: false,
                                      hasPrefixIcon: true,
                                      prefixIcon: Icons.search,
                                      hasOnChanged: false),
                                ),
                                // query snapshot
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: userPosts.length,
                                    itemBuilder: (context, index) {
                                      final postTime =
                                          Timestamp.fromMillisecondsSinceEpoch(
                                              userPosts[index]['timestamp']
                                                  as int);
                                      print(postTime);
                                      final formattedPostTime =
                                          timeago.format(postTime.toDate());
                                      print(formattedPostTime);
                                      final user =
                                          FirebaseAuth.instance.currentUser!;
                                      return Container(
                                        margin: const EdgeInsets.only(
                                            left: 30, right: 30, top: 25),
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 10),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 134, 207, 191),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                                    userPosts[
                                                                            index]
                                                                        [
                                                                        'image'],
                                                                    height: 100,
                                                                    width: 100),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                                userPosts[index]['image'] !=
                                                        null
                                                    ? const SizedBox(width: 10)
                                                    : const SizedBox(),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userPosts[index]
                                                            ['title'],
                                                        style:
                                                            GoogleFonts.georama(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(255, 35,
                                                              141, 123),
                                                        ),
                                                      ),
                                                      Text(
                                                        userPosts[index]
                                                            ['description'],
                                                        style:
                                                            GoogleFonts.georama(
                                                          fontSize: 10,
                                                          color: const Color
                                                              .fromARGB(
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
                                                        '@${userPosts[index]['userName']}',
                                                        style:
                                                            GoogleFonts.georama(
                                                          fontSize: 12,
                                                          color: Color.fromARGB(
                                                              255, 16, 66, 58),
                                                        ),
                                                      ),
                                                      // show time of post
                                                      // DateTime fetchedTime = DateTime.fromMillisecondsSinceEpoch(data['time']);
                                                      Text(
                                                        formattedPostTime,
                                                        style:
                                                            GoogleFonts.georama(
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
                                                        if (userPosts[index]
                                                                    ['likes']
                                                                .contains(user
                                                                    .email) !=
                                                            true) {
                                                          print(
                                                              '---------------${userPosts[index]['likes']}');
                                                          userPosts[index]
                                                              .reference
                                                              .update({
                                                            'likes': FieldValue
                                                                .arrayUnion([
                                                              user.email
                                                            ]),
                                                            'likeCount':
                                                                FieldValue
                                                                    .increment(
                                                                        1),
                                                          });
                                                        } else {
                                                          print(
                                                              'ehe---------------?${userPosts[index]['likes']}');
                                                          userPosts[index]
                                                              .reference
                                                              .update({
                                                            'likes': FieldValue
                                                                .arrayRemove([
                                                              user.email
                                                            ]),
                                                            'likeCount':
                                                                FieldValue
                                                                    .increment(
                                                                        -1)
                                                          });
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: userPosts[index]
                                                                    ['likes']
                                                                .contains(
                                                                    user.email)
                                                            ? Colors.red
                                                            : Colors.black,
                                                        size: 10)),
                                                Text(userPosts[index]
                                                        ['likeCount']
                                                    .toString()),
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
                              ],
                            ));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Skeletonizer(
                              enabled: true,
                              child: Column(
                                children: [
                                  // search bar
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 40, right: 40, top: 25),
                                    child: CustomTextFieldDescription(false,
                                        controller: searchController,
                                        maxLines: 1,
                                        hintText: 'Search',
                                        obscureText: false,
                                        hasLabel: false,
                                        hasPrefixIcon: true,
                                        prefixIcon: Icons.search,
                                        hasOnChanged: true),
                                  ),

                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: 5,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              left: 40, right: 40, top: 25),
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 10),
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 134, 207, 191),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                        child: Icon(
                                                            Icons.abc_outlined),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                          width: 100,
                                                          child: Text('Title'),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                          width: 200,
                                                          child: Text(
                                                              'Description'),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                          width: 100,
                                                          child:
                                                              Text('Username'),
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
                                ],
                              ),
                            );
                            // return const Center(
                            //     child: CircularProgressIndicator());
                          } else {
                            return const Center(child: Text('Error'));
                          }
                        })
                  ],
                ),
              )),
            )));
  }
}
