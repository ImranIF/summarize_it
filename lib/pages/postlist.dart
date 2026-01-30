import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:summarize_it/components/customtextfield.dart';
import 'package:summarize_it/screen/commentscreen.dart';
import 'package:widget_zoom/widget_zoom.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:supabase_flutter/supabase_flutter.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => PostListState();
}

class PostListState extends State<PostList> {
  final searchController = TextEditingController();
  final _postsPerPage = 5;
  var _currentPage = 1;
  List<Map<String, dynamic>> allPosts = [];
  List<Map<String, dynamic>> filteredPosts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      String searchText = searchController.text.toLowerCase();
      if (searchText.isEmpty) {
        filteredPosts = List.from(allPosts);
      } else {
        filteredPosts = allPosts
            .where((post) =>
                post['title']?.toLowerCase().contains(searchText) == true ||
                post['description']?.toLowerCase().contains(searchText) == true)
            .toList();
      }
      _currentPage = 1; // Reset to first page when searching
    });
  }

  Future<void> _fetchPosts() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await Supabase.instance.client
          .from('posts')
          .select()
          .order('timestamp', ascending: false);

      setState(() {
        allPosts = List<Map<String, dynamic>>.from(response);
        filteredPosts = List.from(allPosts);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getPostsForCurrentPage() {
    var startIndex = (_currentPage - 1) * _postsPerPage;
    var endIndex = startIndex + _postsPerPage;

    if (startIndex >= filteredPosts.length) {
      return [];
    }

    return filteredPosts.sublist(
        startIndex, endIndex.clamp(0, filteredPosts.length));
  }

  Future<void> _toggleLike(Map<String, dynamic> post) async {
    final currentUser = Supabase.instance.client.auth.currentUser;
    if (currentUser?.email == null) return;

    final userEmail = currentUser!.email!;
    List<dynamic> likes = List.from(post['likes'] ?? []);

    bool isLiked = likes.contains(userEmail);

    if (isLiked) {
      likes.remove(userEmail);
    } else {
      likes.add(userEmail);
    }

    try {
      await Supabase.instance.client.from('posts').update({
        'likes': likes,
        'likeCount': likes.length,
      }).eq('id', post['id']);

      // Update local state
      setState(() {
        post['likes'] = likes;
        post['likeCount'] = likes.length;
      });
    } catch (e) {
      print('Error updating like: $e');
    }
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
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: CustomTextField(
                  false,
                  controller: searchController,
                  hintText: 'Search posts...',
                  obscureText: false,
                  labelText: 'Search',
                  prefixIcon: Icons.search,
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredPosts.isEmpty
                        ? Center(
                            child: Text(
                              'No posts found',
                              style: GoogleFonts.merriweather(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchPosts,
                            child: ListView.builder(
                              itemCount: _getPostsForCurrentPage().length,
                              itemBuilder: (context, index) {
                                final post = _getPostsForCurrentPage()[index];
                                final currentUser =
                                    Supabase.instance.client.auth.currentUser;
                                final isLiked = currentUser != null &&
                                    (post['likes'] as List?)
                                            ?.contains(currentUser.email) ==
                                        true;

                                return Container(
                                  margin: const EdgeInsets.only(
                                      left: 30, right: 30, top: 25),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 134, 207, 191),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: Text(
                                                post['userName']?[0] ?? 'U'),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post['userName'] ??
                                                      'Unknown User',
                                                  style:
                                                      GoogleFonts.merriweather(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  _formatTimestamp(
                                                      post['timestamp']),
                                                  style:
                                                      GoogleFonts.merriweather(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        post['title'] ?? '',
                                        style: GoogleFonts.merriweather(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        post['description'] ?? '',
                                        style: GoogleFonts.merriweather(),
                                      ),
                                      if (post['image'] != null) ...[
                                        const SizedBox(height: 12),
                                        WidgetZoom(
                                          heroAnimationTag:
                                              'post-${post['id']}',
                                          zoomWidget: Image.network(
                                            post['image'],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                height: 100,
                                                color: Colors.grey[300],
                                                child: const Icon(
                                                    Icons.image_not_supported),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () => _toggleLike(post),
                                            icon: Icon(
                                              Icons.favorite_rounded,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black,
                                            ),
                                          ),
                                          Text('${post['likeCount'] ?? 0}'),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentScreen(
                                                    postId:
                                                        post['id'].toString(),
                                                    postTitle:
                                                        post['title'] ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.comment_outlined),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              if (filteredPosts.isNotEmpty) _buildPaginationControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (filteredPosts.length / _postsPerPage).ceil();
    if (totalPages <= 1) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed:
                _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            child: const Text('Previous'),
          ),
          Text('Page $_currentPage of $totalPages'),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) return '';

      DateTime dateTime;
      if (timestamp is String) {
        dateTime = DateTime.parse(timestamp);
      } else if (timestamp is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return '';
      }

      return timeago.format(dateTime);
    } catch (e) {
      return '';
    }
  }
}
