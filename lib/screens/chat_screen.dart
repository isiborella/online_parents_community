import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatName;

  const ChatScreen({super.key, required this.chatName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<Map<String, dynamic>> messages;

  @override
  void initState() {
    super.initState();
    // Dummy chat data based on user
    messages = getDummyMessages(widget.chatName);
  }

  List<Map<String, dynamic>> getDummyMessages(String name) {
    switch (name) {
      case 'Alice':
        return [
          {
            'text': "Hey! How's it going?",
            'isMe': false,
            'time': "10:00 AM",
            'seen': true,
          },
          {
            'text': "Hi Alice! I'm good 😊",
            'isMe': true,
            'time': "10:02 AM",
            'seen': true,
          },
          {
            'text': "Wanna catch up later?",
            'isMe': false,
            'time': "10:05 AM",
            'seen': false,
          },
        ];
      case 'Bob':
        return [
          {
            'text': "Hey! Are you coming tomorrow?",
            'isMe': false,
            'time': "Yesterday",
            'seen': true,
          },
          {
            'text': "Yes, I'll be there!",
            'isMe': true,
            'time': "Yesterday",
            'seen': true,
          },
        ];
      case 'Charlie':
        return [
          {
            'text': "Check this out 👍",
            'isMe': false,
            'time': "09:00 AM",
            'seen': true,
          },
          {'text': "Nice one!", 'isMe': true, 'time': "09:05 AM", 'seen': true},
        ];
      case 'Diana':
        return [
          {
            'text': "See you at the park!",
            'isMe': false,
            'time': "Mon",
            'seen': true,
          },
          {'text': "Can't wait 😍", 'isMe': true, 'time': "Mon", 'seen': true},
        ];
      default:
        return [];
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      messages.add({
        'text': _messageController.text.trim(),
        'isMe': true,
        'time': DateFormat.jm().format(DateTime.now()),
        'seen': false,
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // This is the background color
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF00BFA5), // Accent color
              child: Text(
                widget.chatName[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.chatName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onPressed: () {
              // Options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: msg['isMe']
                          ? const Color(0xFF00BFA5)
                          : const Color(0xFF424242),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              msg['time'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                            if (msg['isMe']) ...[
                              const SizedBox(width: 4),
                              Icon(
                                msg['seen'] ? Icons.done_all : Icons.done,
                                size: 14,
                                color: msg['seen']
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(
                        0xFFF5F7FA,
                      ), // Matches screen background
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Color(0xFF212121)),
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        hintStyle: TextStyle(color: Color(0xFFB0BEC5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  backgroundColor: const Color(0xFF00BFA5),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
