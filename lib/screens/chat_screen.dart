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

  void _sendAudio() {
    setState(() {
      messages.add({
        'text': '🎤 Audio message',
        'isMe': true,
        'time': DateFormat.jm().format(DateTime.now()),
        'seen': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        title: Row(
          children: [
            // Back button
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 4),
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue[400],
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
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Align(
                  alignment: msg['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: GestureDetector(
                    onLongPress: () {
                      // Optional: swipe to reply / copy
                    },
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
                        gradient: msg['isMe']
                            ? const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFF37474F), Color(0xFF263238)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(msg['isMe'] ? 16 : 0),
                          bottomRight: Radius.circular(msg['isMe'] ? 0 : 16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            msg['text'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                msg['time'],
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: 4),
                              if (msg['isMe'])
                                Icon(
                                  msg['seen'] ? Icons.done_all : Icons.done,
                                  size: 14,
                                  color: msg['seen']
                                      ? Colors.blueAccent
                                      : Colors.white54,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            color: const Color(0xFF1B263B),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.greenAccent),
                  onPressed: _sendAudio,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Message...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF0D1B2A),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
