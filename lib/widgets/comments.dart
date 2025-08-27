class Comment {
  final String user;
  final String text;

  Comment({required this.user, required this.text});
}

// Mock data to simulate comments coming from a backend.
final List<Comment> mockComments = [
  Comment(user: 'Parent A', text: 'This is such a great point!'),
  Comment(user: 'Parent B', text: 'I totally agree with this.'),
  Comment(user: 'New Dad', text: 'Thanks for sharing these tips!'),
];
