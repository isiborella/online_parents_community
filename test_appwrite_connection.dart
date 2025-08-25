// Test script to verify Appwrite connection and collection setup
// Run this after setting up the Appwrite collection to test connectivity

import 'package:appwrite/appwrite.dart';

void main() async {
  print('🧪 Testing Appwrite Connection...');
  
  final client = Client();
  
  try {
    // Initialize client with your project settings
    client
      .setEndpoint('https://nyc.cloud.appwrite.io/v1')
      .setProject('68a714550022e0e26594')
      .setSelfSigned(status: true);
    
    final databases = Databases(client);
    
    print('🔗 Testing database connection...');
    
    // Try to list documents in the posts collection
    final response = await databases.listDocuments(
      databaseId: '68a7209e0033e67e945c',
      collectionId: 'posts',
      queries: [Query.limit(1)],
    );
    
    print('✅ Successfully connected to Appwrite!');
    print('📊 Collection contains ${response.total} documents');
    
    if (response.documents.isNotEmpty) {
      print('📝 Sample document:');
      print(response.documents.first.data);
    }
    
  } catch (e) {
    print('❌ Connection failed: $e');
    print('\n🔧 Troubleshooting tips:');
    print('1. Make sure the collection "posts" exists in database "68a7209e0033e67e945c"');
    print('2. Verify your project ID: 68a714550022e0e26594');
    print('3. Check that the endpoint is correct: https://nyc.cloud.appwrite.io/v1');
    print('4. Ensure you have proper permissions set on the collection');
  }
}
