import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../models/post.dart';

class PostsPage extends StatefulWidget {
  final User user;
  const PostsPage({super.key, required this.user});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with SingleTickerProviderStateMixin {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.getPosts(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Posts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom du user en haut
            Text(
              widget.user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Liste des posts
            Expanded(
              child: FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Failed to load posts"));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No posts found"));
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];

                        // Animation : fade + slide
                        return TweenAnimationBuilder<Offset>(
                          duration: Duration(milliseconds: 300 + index * 100),
                          tween: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero),
                          builder: (context, offset, child) {
                            return Transform.translate(
                              offset: Offset(0, offset.dy * 50),
                              child: Opacity(opacity: 1 - offset.dy.abs() * 2, child: child),
                            );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID: ${post.id}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(
                                    post.title,
                                    style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(post.body,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
