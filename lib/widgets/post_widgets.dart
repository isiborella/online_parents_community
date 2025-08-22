import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // Appwrite stores datetime as ISO string, e.g. "2025-08-21T10:30:00.000Z"
    final timestamp = post['timestamp'] != null
        ? DateTime.tryParse(post['timestamp'])
        : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        elevation: 4,
        color: Colors.white10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- Top Row: Avatar + Name + Timestamp ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      post['profileImageUrl'] ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['displayName'] ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          timestamp != null
                              ? '${timestamp.day}/${timestamp.month}/${timestamp.year} • ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}'
                              : 'Posted: N/A',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// --- Post Content ---
              if (post['content'] != null &&
                  (post['content'] as String).trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  post['content'],
                  style: const TextStyle(fontSize: 15.5),
                ),
              ],

              /// --- Post Image ---
              if (post['mediaUrl'] != null) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    post['mediaUrl'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Text("Image failed to load"),
                  ),
                ),
              ],

              const SizedBox(height: 10),
              const Divider(),

              /// --- Actions ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Like functionality with Appwrite
                    },
                    icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                    label: Text('${post['likes'] ?? 0} Likes'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Comment functionality with Appwrite
                    },
                    icon: const Icon(Icons.comment_outlined, size: 18),
                    label: Text('${post['comments'] ?? 0} Comments'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
