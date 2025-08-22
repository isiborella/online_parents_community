import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class ProfileScreen extends StatefulWidget {
  final String? userId; // optional: to view another user's profile
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final client = Client();
  late Databases databases;

  final String databaseId = '68a7209e0033e67e945c';
  final String usersCollectionId = '68a71a0b001b1be4b040'; // check in Appwrite console
  final String postsCollectionId = '68a7222d0036facdd548'; // check in Appwrite console

  models.Document? userDoc;
  List<models.Document> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    client
      ..setEndpoint('https://nyc.cloud.appwrite.io/v1') // your Appwrite endpoint
      ..setProject('68a714550022e0e26594');

    databases = Databases(client);

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileUserId = widget.userId ?? "68a71a0b001b1be4b040";
      // Replace with logged-in user ID from Appwrite account service

      // get user document
      final user = await databases.getDocument(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        documentId: profileUserId,
      );

      // get posts by this user
      final userPosts = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: postsCollectionId,
        queries: [
          Query.equal('68a71a0b001b1be4b040', profileUserId),
          Query.orderDesc('timestamp'),
        ],
      );

      setState(() {
        userDoc = user;
        posts = userPosts.documents;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (userDoc == null) {
      return const Scaffold(body: Center(child: Text("User not found.")));
    }

    final userData = userDoc!.data;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      userData['profileImageUrl'] ??
                          'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['displayName'] ?? 'User',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Parent of: ${userData['childAge'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['bio'] ?? 'No bio provided.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'My Posts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            posts.isEmpty
                ? const Text("No posts to display.")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index].data;
                      return ListTile(
                        title: Text(post['title'] ?? "Untitled"),
                        subtitle: Text(post['content'] ?? ""),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
