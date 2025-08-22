import 'dart:io' show File; // only available on mobile
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postController = TextEditingController();
  final _picker = ImagePicker();
  bool _isUploading = false;

  File? _imageFile;         // for mobile
  Uint8List? _imageBytes;   // for web

  final Client client = Client();
  late final Storage storage;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint('https://nyc.cloud.appwrite.io/v1') // 👈 change to your Appwrite endpoint
        .setProject('68a714550022e0e26594')
        .setSelfSigned(status: true);     // 👈 replace with your project ID
    storage = Storage(client);
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
        bucketId: 'your_bucket_id', // 👈 replace with your storage bucket ID
        fileId: fileId,
        file: inputFile,
      );

      // Return the Appwrite file ID (you can later build a URL to fetch it)
      return result.$id;

    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> _submitPost() async {
    if (_postController.text.isEmpty && _imageFile == null && _imageBytes == null) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final imageId = await _uploadImage();

    // TODO: Save post data to your Appwrite database (collection: "posts")
    // Example:
    // await databases.createDocument(
    //   databaseId: 'your_database_id',
    //   collectionId: 'posts',
    //   documentId: ID.unique(),
    //   data: {
    //     'content': _postController.text,
    //     'imageId': imageId,
    //     'timestamp': DateTime.now().toIso8601String(),
    //   },
    // );

    setState(() {
      _isUploading = false;
    });

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
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Publish Post"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            )
          ],
        ),
      ),
    );
  }
}
