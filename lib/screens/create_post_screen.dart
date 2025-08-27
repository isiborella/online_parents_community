import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Appwrite imports are now commented out
// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  final _picker = ImagePicker();
  bool _isUploading = false;

  File? _imageFile; // Mobile
  Uint8List? _imageBytes; // Web

  // Appwrite clients are now commented out
  // final Client client = Client();
  // late final Storage storage;
  // late final Databases databases;

  static const Color accentColor = Color(0xFF0A2647);
  static const Color lightBackground = Color(0xFFF5F7FA);

  @override
  void initState() {
    super.initState();
    // Appwrite client initialization is now commented out
    // client
    //     .setEndpoint('https://nyc.cloud.appwrite.io/v1')
    //     .setProject('YOUR_PROJECT_ID')
    //     .setSelfSigned(status: true);
    // storage = Storage(client);
    // databases = Databases(client);
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() => _imageBytes = bytes);
      } else {
        setState(() => _imageFile = File(pickedFile.path));
      }
    }
  }

  // Appwrite image upload logic is now commented out
  /*
  Future<String?> _uploadImage() async {
    if (_imageFile == null && _imageBytes == null) return null;
    try {
      final fileId = ID.unique();
      InputFile inputFile;

      if (kIsWeb) {
        inputFile = InputFile.fromBytes(
          bytes: _imageBytes!,
          filename: "post_${DateTime.now().millisecondsSinceEpoch}.png",
        );
      } else {
        inputFile = InputFile.fromPath(
          path: _imageFile!.path,
          filename: "post_${DateTime.now().millisecondsSinceEpoch}.png",
        );
      }

      final result = await storage.createFile(
        bucketId: 'YOUR_BUCKET_ID',
        fileId: fileId,
        file: inputFile,
      );
      return result.$id;
    } catch (e) {
      return null;
    }
  }
  */

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty &&
        _imageFile == null &&
        _imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add content or an image to your post.'),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    // This section now simulates a network call for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Appwrite document creation is now commented out
    /*
    final imageId = await _uploadImage();
    try {
      String? mediaUrl;
      if (imageId != null) {
        mediaUrl = 'https://your.endpoint.com/v1/storage/buckets/YOUR_BUCKET_ID/files/$imageId/view';
      }

      await databases.createDocument(
        databaseId: 'YOUR_DATABASE_ID',
        collectionId: 'YOUR_COLLECTION_ID',
        documentId: ID.unique(),
        data: {
          'content': _postController.text,
          'imageId': imageId,
          'mediaUrl': mediaUrl,
          'timestamp': DateTime.now().toIso8601String(),
          'userId': 'current_user_id',
          'displayName': 'Current User',
          'profileImageUrl': 'https://via.placeholder.com/150',
          'likes': 0,
          'comments': 0,
        },
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }
    */

    // UI feedback for success
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Post created successfully!')));

    setState(() => _isUploading = false);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        title: const Text(
          "Create Post",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: accentColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: 4,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (kIsWeb && _imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  _imageBytes!,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            if (!kIsWeb && _imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(_imageFile!, height: 200, fit: BoxFit.cover),
              ),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image, color: accentColor),
              label: const Text(
                "Add Image",
                style: TextStyle(color: accentColor),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isUploading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Publish Post",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
