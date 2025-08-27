import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';

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

  final Client client = Client();
  late final Storage storage;
  late final Databases databases;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint('https://nyc.cloud.appwrite.io/v1')
        .setProject('68a714550022e0e26594')
        .setSelfSigned(status: true);
    storage = Storage(client);
    databases = Databases(client);
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
        bucketId: '68a7196f00082654543d',
        fileId: fileId,
        file: inputFile,
      );

      return result.$id;
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty &&
        _imageFile == null &&
        _imageBytes == null)
      return;

    setState(() => _isUploading = true);

    final imageId = await _uploadImage();

    try {
      String? mediaUrl;
      if (imageId != null) {
        mediaUrl =
            'https://nyc.cloud.appwrite.io/v1/storage/buckets/68a7196f00082654543d/files/$imageId/view';
      }

      await databases.createDocument(
        databaseId: '68a7209e0033e67e945c',
        collectionId: '68a7222d0036facdd548',
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
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create post: $e')));
    }

    setState(() => _isUploading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Create Post"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1B263B),
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
              icon: const Icon(Icons.image, color: Colors.greenAccent),
              label: const Text(
                "Add Image",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black87,
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
