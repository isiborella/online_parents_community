import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import '../widgets/post_widgets.dart';
import 'screens/create_post_screen.dart';

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
        databaseId: '68a7209e0033e67e945c',
        collectionId: 'posts', // your collection
        queries: [Query.orderDesc('timestamp')],
      );
      setState(() {
        posts = response.documents;
        isLoading = false;
      });
    } catch (e) {
      // print("Error fetching posts: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Community'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? Center(child: Text('No posts yet. Be the first to share!'))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index].data;
                return PostWidget(post: post);
              },
            ),
    );
  }
}
