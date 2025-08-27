import 'package:flutter/material.dart';
import '../widgets/post_widgets.dart';
import 'screens/create_post_screen.dart';
import 'dart:ui';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;

  // Define the new accent color
  static const Color accentColor = Color(0xFF0A2647);

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Hardcoded sample posts data
    final samplePosts = [
      {
        'title': 'Welcome to the Parent Community!',
        'content':
            'This is a safe space for parents to share experiences, ask questions, and support each other. Feel free to post about parenting challenges, milestones, or just share your day!',
        'userId': 'admin',
        'timestamp': '2024-01-15T10:30:00Z',
      },
      {
        'title': 'Sleep Training Tips',
        'content':
            'Has anyone had success with gentle sleep training methods? My 8-month-old still wakes up every 2-3 hours and I\'m exhausted. Looking for advice from experienced parents!',
        'userId': 'parent123',
        'timestamp': '2024-01-14T15:45:00Z',
      },
      {
        'title': 'Healthy Snack Ideas for Toddlers',
        'content':
            'My 2-year-old is getting picky with food. What are some healthy, easy-to-make snacks that your toddlers actually enjoy eating?',
        'userId': 'mom_of_two',
        'timestamp': '2024-01-13T09:15:00Z',
      },
      {
        'title': 'Dealing with Screen Time',
        'content':
            'How do you manage screen time for your kids? I\'m trying to find a balance between educational content and limiting overall screen exposure.',
        'userId': 'tech_parent',
        'timestamp': '2024-01-12T14:20:00Z',
      },
      {
        'title': 'First Day of School Tips',
        'content':
            'My little one is starting kindergarten next week! Any advice for making the transition smoother? Both of us are a bit nervous about this big step.',
        'userId': 'new_school_mom',
        'timestamp': '2024-01-11T11:00:00Z',
      },
    ];

    setState(() {
      posts = samplePosts;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        color: const Color(0xFFF5F7FA), // Soft gray background
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: accentColor,
                ), // Updated color
              )
            : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    floating: true,
                    pinned: true,
                    expandedHeight: 80.0, // Fixed height for a clean look
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              'https://via.placeholder.com/150',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFF5F7FA,
                                ), // Matches the body background
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFB0BEC5),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final post = posts[index];
                      return PostWidget(
                        post: {
                          'title': post['title'] ?? 'Untitled',
                          'content': post['content'] ?? 'No content available',
                          'userId': post['userId'] ?? 'Anonymous',
                          'timestamp': post['timestamp'] ?? '',
                        },
                      );
                    }, childCount: posts.length),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor, // Updated color
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
