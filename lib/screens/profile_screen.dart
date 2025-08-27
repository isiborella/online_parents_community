import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId; // optional: view another user's profile
  const ProfileScreen({super.key, this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // New navy blue accent color
  static const Color accentColor = Color(0xFF0A2647);
  // New light navy blue for text post background
  static const Color lightAccentColor = Color(0xFFE0E7ED);

  final Map<String, dynamic> mockUserData = {
    'displayName': 'Jane Doe',
    'bio': 'A community for parents, by parents.',
    'profileImageUrl': 'https://via.placeholder.com/150',
    'postsCount': 15,
    'followers': 120,
    'following': 90,
  };

  final List<Map<String, dynamic>> mockPosts = [
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=1'},
    {
      'type': 'text',
      'content':
          'Here is my first text-based post! I am really excited to share my thoughts here.',
    },
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=2'},
    {
      'type': 'text',
      'content':
          'A quick update for everyone. Hope you are all doing well today.',
    },
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=3'},
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=4'},
    {
      'type': 'text',
      'content':
          'Just wanted to say hello to the community! This platform has been so helpful.',
    },
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=5'},
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=6'},
    {'type': 'text', 'content': 'New features are coming soon. Stay tuned!'},
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=7'},
    {'type': 'image', 'content': 'https://picsum.photos/200/200?random=8'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = mockUserData;
    final posts = mockPosts;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF424242)),
            onPressed: () {
              // TODO: Navigate to settings screen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// --- Profile Header & Stats ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: NetworkImage(userData['profileImageUrl']),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['displayName'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userData['bio'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  /// --- Stats Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        userData['postsCount'].toString(),
                        "Posts",
                      ),
                      _buildStatColumn(
                        userData['followers'].toString(),
                        "Followers",
                      ),
                      _buildStatColumn(
                        userData['following'].toString(),
                        "Following",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// --- Action Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to Edit Profile screen
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// --- Tab Bar for Posts ---
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: accentColor,
                labelColor: accentColor,
                unselectedLabelColor: Colors.grey[600],
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on), text: "Posts"),
                  Tab(icon: Icon(Icons.turned_in_not), text: "Saved"),
                ],
              ),
            ),

            /// --- Tab Content (Posts Grid) ---
            SizedBox(
              height: 400, // Fixed height for the TabBarView
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Posts Grid View
                  GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      if (post['type'] == 'image') {
                        return Image.network(
                          post['content'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                              ),
                        );
                      } else {
                        return _TextPostCard(text: post['content']);
                      }
                    },
                  ),
                  // Saved Posts (Dummy)
                  const Center(
                    child: Text(
                      "No saved posts yet.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}

/// A simple card widget for displaying text-based posts in the grid.
class _TextPostCard extends StatelessWidget {
  final String text;

  const _TextPostCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: _ProfileScreenState.lightAccentColor, // Updated color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Color(0xFF424242), fontSize: 12),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
