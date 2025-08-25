import 'dart:io' show File; // only available on mobile
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

  File? _imageFile; // for mobile
  Uint8List? _imageBytes; // for web

  final Client client = Client();
  late final Storage storage;
  late final Databases databases;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint(
          'https://nyc.cloud.appwrite.io/v1',
        ) // 👈 change to your Appwrite endpoint
        .setProject('68a714550022e0e26594')
        .setSelfSigned(status: true); // 👈 replace with your project ID
    storage = Storage(client);
    databases = Databases(client);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
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
        bucketId:
            '68a7196f00082654543d', // 👈 replace with your storage bucket ID
        fileId: fileId,
        file: inputFile,
      );

      // Return the Appwrite file ID (you can later build a URL to fetch it)
      return result.$id;
    } catch (e) {
      // print("Upload error: $e");
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty &&
        _imageFile == null &&
        _imageBytes == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageId = await _uploadImage();

    try {
      // Generate media URL from imageId if an image was uploaded
      String? mediaUrl;
      if (imageId != null) {
        mediaUrl = 'https://nyc.cloud.appwrite.io/v1/storage/buckets/68a7196f00082654543d/files/$imageId/view';
      }

      await databases.createDocument(
        databaseId: '68a7209e0033e67e945c', // Same database ID as home page
        collectionId: 'posts',
        documentId: ID.unique(),
        data: {
          'content': _postController.text,
          'imageId': imageId,
          'mediaUrl': mediaUrl,
          'timestamp': DateTime.now().toIso8601String(),
          'userId': 'current_user_id', // Placeholder - replace with actual user ID
          'displayName': 'Current User', // Placeholder - replace with actual display name
          'profileImageUrl': 'https://via.placeholder.com/150', // Placeholder
          'likes': 0,
          'comments': 0,
        },
      );
    } catch (e) {
      // Error handling for database operation
      final context = this.context;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create post: $e')),
      );
    }

    setState(() {
      _isUploading = false;
    });

    final context = this.context; // Store context locally
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            if (kIsWeb && _imageBytes != null)
              Image.memory(_imageBytes!, height: 150, fit: BoxFit.cover),
            if (!kIsWeb && _imageFile != null)
              Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
            TextButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text("Add Image"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isUploading ? null : _submitPost,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Publish Post"),
            ),
          ],
        ),
      ),
    );
  }
}
