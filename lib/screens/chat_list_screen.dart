import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Map<String, dynamic>> chats = [
    {
      "name": "Alice",
      "lastMessage": "Hey, how are you?",
      "time": "10:30 AM",
      "online": true,
    },
    {
      "name": "Bob",
      "lastMessage": "Let’s meet tomorrow.",
      "time": "Yesterday",
      "online": false,
    },
    {
      "name": "Charlie",
      "lastMessage": "Got it 👍",
      "time": "09:15 AM",
      "online": true,
    },
    {
      "name": "Diana",
      "lastMessage": "See you soon!",
      "time": "Mon",
      "online": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            floating: true,
            pinned: true,
            expandedHeight: 80.0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Text(
                    "Chats",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xFF424242),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Color(0xFFB0BEC5)),
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final chat = chats[index];
              return Slidable(
                key: ValueKey(chat["name"]),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          chats.removeAt(index);
                        });
                      },
                      backgroundColor: Colors.red[400]!,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFF00BFA5),
                    child: Text(
                      chat["name"]![0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    chat["name"] ?? "",
                    style: const TextStyle(
                      color: Color(0xFF212121),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chat["lastMessage"] ?? "",
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    chat["time"] ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(chatName: chat["name"] ?? "Unknown"),
                      ),
                    );
                  },
                ),
              );
            }, childCount: chats.length),
          ),
        ],
      ),
    );
  }
}
