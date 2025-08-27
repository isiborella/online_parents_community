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
      // "online": true,
    },
    {
      "name": "Bob",
      "lastMessage": "Let’s meet tomorrow.",
      "time": "Yesterday",
      // "online": false,
    },
    {
      "name": "Charlie",
      "lastMessage": "Got it 👍",
      "time": "09:15 AM",
      // "online": true,
    },
    {
      "name": "Diana",
      "lastMessage": "See you soon!",
      "time": "Mon",
      // "online": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
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
                  backgroundColor: Colors.red,
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
                backgroundColor: Colors.blue[400],
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
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                chat["lastMessage"] ?? "",
                style: const TextStyle(color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white70),
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
        },
      ),
    );
  }
}




// List<Map<String, dynamic>> chats = [
//     {
//       "name": "Alice",
//       "lastMessage": "Hey, how are you?",
//       "time": "10:30 AM",
//       "online": true,
//     },
//     {
//       "name": "Bob",
//       "lastMessage": "Let’s meet tomorrow.",
//       "time": "Yesterday",
//       "online": false,
//     },
//     {
//       "name": "Charlie",
//       "lastMessage": "Got it 👍",
//       "time": "09:15 AM",
//       "online": true,
//     },
//     {
//       "name": "Diana",
//       "lastMessage": "See you soon!",
//       "time": "Mon",
//       "online": false,
//     },