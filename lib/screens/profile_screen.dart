import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class ProfileScreen extends StatefulWidget {
  final String? userId; // optional: view another user's profile
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final client = Client();
  late Databases databases;
  late Account account;

  final String databaseId = '68a7209e0033e67e945c';
  final String usersCollectionId = '68a7223c0034b2a45e19';
  final String postsCollectionId = '68a7222d0036facdd548';

  models.Document? userDoc;
  List<models.Document> posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    client
      ..setEndpoint('https://nyc.cloud.appwrite.io/v1')
      ..setProject('68a714550022e0e26594');

    databases = Databases(client);
    account = Account(client);

    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading =true);
    try {
      final profileUserId = widget.userId ?? (await account.get()).$id;

      final userList = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: usersCollectionId,
        queries: [Query.equal('accountId', profileUserId)],
      );

      if (userList.documents.isEmpty) {
        setState(() {
          userDoc = null;
          isLoading = false;
        });
        return;
      }

      final user = userList.documents.first;

      final userPosts = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: postsCollectionId,
        queries: [
          Query.equal('userId', profileUserId),
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
      return const Scaffold(
        backgroundColor: Color(0xFF1B0033), // deep purple background
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (userDoc == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1B0033),
        body: Center(
          child: Text(
            "User not found.",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final userData = userDoc!.data;

    return Scaffold(
      backgroundColor: const Color(0xFF1B0033), // deep purple
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Parent of: ${userData['childAge'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(
                  userData['bio'] ?? 'No bio provided.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'My Posts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          posts.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "No posts to display.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index].data;
                    return Card(
                      color: Colors.white10,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          post['title'] ?? "Untitled",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          post['content'] ?? "",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
