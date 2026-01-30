import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:summarize_it/models/usermodel.dart';
import 'package:summarize_it/provider/userprovider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String postTitle;
  const CommentScreen({super.key, required this.postId, this.postTitle = ''});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late final UserModel? userModel =
      Provider.of<UserProvider>(context).userModel;
  late String userImageURL;
  TextEditingController commentController = TextEditingController();
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final response = await Supabase.instance.client
          .from('comments')
          .select()
          .eq('postId', widget.postId)
          .order('timestamp', ascending: false);

      setState(() {
        comments = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (commentController.text.trim().isEmpty) return;

    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser?.email == null) return;

    try {
      final commentData = {
        'postId': widget.postId,
        'text': commentController.text.trim(),
        'userEmail': currentUser!.email!,
        'user_id': currentUser.id, // Add Supabase user ID
        'userName': userModel?.userName ?? 'Unknown User',
        'userImageURL': userModel?.imageURL ?? '',
        'timestamp': DateTime.now().toIso8601String(),
        'likes': <String>[],
        'likeCount': 0,
      };

      await Supabase.instance.client.from('comments').insert(commentData);

      commentController.clear();
      _fetchComments(); // Refresh comments
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
    }
  }

  Future<void> _toggleCommentLike(Map<String, dynamic> comment) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser?.email == null) return;

    final userEmail = currentUser!.email!;
    List<dynamic> likes = List.from(comment['likes'] ?? []);

    bool isLiked = likes.contains(userEmail);

    if (isLiked) {
      likes.remove(userEmail);
    } else {
      likes.add(userEmail);
    }

    try {
      await Supabase.instance.client.from('comments').update({
        'likes': likes,
        'likeCount': likes.length,
      }).eq('id', comment['id']);

      // Update local state
      setState(() {
        comment['likes'] = likes;
        comment['likeCount'] = likes.length;
      });
    } catch (e) {
      print('Error updating comment like: $e');
    }
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
                  commentBar(context),
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: isLoading
                          ? Column(
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
                            )
                          : comments.isEmpty
                              ? const Text('No comments')
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: comments.length,
                                  itemBuilder: (context, index) {
                                    final comment = comments[index];
                                    DateTime commentTime;
                                    try {
                                      if (comment['timestamp'] is String) {
                                        commentTime = DateTime.parse(
                                            comment['timestamp']);
                                      } else if (comment['timestamp'] is int) {
                                        commentTime =
                                            DateTime.fromMillisecondsSinceEpoch(
                                                comment['timestamp']);
                                      } else {
                                        commentTime = DateTime.now();
                                      }
                                    } catch (e) {
                                      commentTime = DateTime.now();
                                    }

                                    print(
                                        'Time of the comment: ------------$commentTime-----------------');
                                    final formattedTime =
                                        timeago.format(commentTime);
                                    final formattedCommentTime =
                                        timeago.format(commentTime);
                                    return Container(
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        bottom: 10,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 10),
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 120, 187, 181),
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
                                              backgroundImage: comment[
                                                              'userImageURL'] !=
                                                          null &&
                                                      comment['userImageURL']
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      comment['userImageURL'],
                                                      height: 20,
                                                      width: 20,
                                                      fit: BoxFit.cover,
                                                    ).image
                                                  : null,
                                              child: comment['userImageURL'] ==
                                                          null ||
                                                      comment['userImageURL']
                                                          .isEmpty
                                                  ? Text(comment['userName']
                                                          ?[0] ??
                                                      'U')
                                                  : null,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  comment['text'] ?? '',
                                                  style: GoogleFonts.cormorant()
                                                      .copyWith(
                                                          fontSize: 12,
                                                          letterSpacing: 1.5,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: const Color
                                                              .fromARGB(255, 35,
                                                              141, 123)),
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
                                                      '@${comment['userName'] ?? 'Unknown'}',
                                                      style: GoogleFonts
                                                              .cormorantSc()
                                                          .copyWith(
                                                              fontSize: 12,
                                                              // letterSpacing: 1.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  27, 110, 97)),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 20),
                                                      child: Row(
                                                        children: [
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              onTap: () =>
                                                                  _toggleCommentLike(
                                                                      comment),
                                                              child: Icon(
                                                                Icons
                                                                    .thumb_up_sharp,
                                                                size: 15,
                                                                color: (comment['likes']
                                                                                as List?)
                                                                            ?.contains(userModel
                                                                                ?.email) ==
                                                                        true
                                                                    ? Colors.red
                                                                    : const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        27,
                                                                        110,
                                                                        97),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Text(
                                                              '${comment['likeCount'] ?? 0}',
                                                              style: const TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          27,
                                                                          110,
                                                                          97))),
                                                          if (comment[
                                                                  'userName'] ==
                                                              userModel
                                                                  ?.userName) ...[
                                                            const SizedBox(
                                                                width: 10),
                                                            Material(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                    customBorder:
                                                                        RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20)),
                                                                    onTap: () {
                                                                      // confirm for deletion
                                                                      displayDeleteDialog(
                                                                          comment);
                                                                    },
                                                                    child: Ink(
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete_forever_rounded,
                                                                        size:
                                                                            15,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            35,
                                                                            141,
                                                                            123),
                                                                      ),
                                                                    )))
                                                          ],
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
                                                          color: const Color
                                                              .fromARGB(255, 35,
                                                              141, 123)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                ])))));
  }

  Container commentBar(BuildContext context) {
    return Container(
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
    );
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
    await _addComment();
  }
}
