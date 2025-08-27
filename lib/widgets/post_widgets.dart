import 'package:flutter/material.dart';
import 'package:online_parents_community/widgets/comments.dart';

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  static const Color accentColor = Color(0xFF0A2647);
  static const Color lightAccentColor = Color(0xFFE0E7ED);

  late int _likesCount;
  late bool _isLiked;
  late bool _isCommentSectionVisible; // New state variable
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post['likes'] ?? 0;
    _isLiked = widget.post['isLiked'] ?? false;
    _isCommentSectionVisible = false; // Initialize to hidden
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likesCount--;
        _isLiked = false;
      } else {
        _likesCount++;
        _isLiked = true;
      }
    });
  }

  void _submitComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isNotEmpty) {
      setState(() {
        mockComments.add(Comment(user: 'Me', text: commentText));
        _commentController.clear();
      });
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = widget.post['timestamp'] != null
        ? DateTime.tryParse(widget.post['timestamp'])
        : null;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Top Row: Avatar + Name + Timestamp ---
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.post['profileImageUrl'] ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post['displayName'] ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFF212121),
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
                if (widget.post['content'] != null &&
                    (widget.post['content'] as String).trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.post['content'],
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
                if (widget.post['mediaUrl'] != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      widget.post['mediaUrl'],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(color: accentColor),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Text("Image failed to load"),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Divider(color: Colors.grey.withOpacity(0.3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked
                            ? Icons.thumb_up_alt
                            : Icons.thumb_up_alt_outlined,
                        size: 18,
                        color: _isLiked ? accentColor : Colors.grey[600],
                      ),
                      label: Text(
                        '$_likesCount Likes',
                        style: TextStyle(
                          color: _isLiked ? accentColor : Colors.grey[600],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isCommentSectionVisible = !_isCommentSectionVisible;
                        });
                      },
                      icon: Icon(
                        Icons.comment_outlined,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                      label: Text(
                        '${mockComments.length} Comments',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.withOpacity(0.3)),
                // --- Comment Section (Conditional) ---
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...mockComments
                          .map(
                            (comment) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${comment.user}: ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(child: Text(comment.text)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 8),
                      // This row is now conditionally rendered
                      if (_isCommentSectionVisible)
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFE0E7ED),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _submitComment,
                              child: CircleAvatar(
                                backgroundColor: accentColor,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
