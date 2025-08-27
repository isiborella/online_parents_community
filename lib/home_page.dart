import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widgets/post_widgets.dart';
import 'screens/create_post_screen.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final client = Client();
  late Databases databases;
  List<Document> posts = [];
  bool isLoading = true;

  final String databaseId = '68a7209e0033e67e945c';
  final String postsCollectionId = '68a7222d0036facdd548';

  @override
  void initState() {
    super.initState();

    client
        .setEndpoint('https://nyc.cloud.appwrite.io/v1')
        .setProject('68a714550022e0e26594');

    databases = Databases(client);

    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: postsCollectionId,
        queries: [Query.orderDesc('timestamp')],
      );

      setState(() {
        posts = response.documents;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching posts: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Parent Community 💬',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: const Color.fromARGB(
          255,
          13,
          0,
          24,
        ), // Deep purple/almost black background
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : posts.isEmpty
            ? const Center(
                child: Text(
                  'No posts yet.\nBe the first to share something 💡',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final data = post.data;

                  final title = data['title'] ?? 'Untitled';
                  final content = data['content'] ?? 'No content available';
                  final author = data['userId'] ?? 'Anonymous';
                  final time = data['timestamp'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: PostWidget(
                            post: {
                              'title': title,
                              'content': content,
                              'userId': author,
                              'timestamp': time,
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.2),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
          );
        },
      ),
    );
  }
}
