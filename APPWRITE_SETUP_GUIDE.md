# Appwrite Setup Guide for Online Parents Community

## Database and Collection Setup

### 1. Create Database
- Database ID: `68a7209e0033e67e945c` (already referenced in code)

### 2. Create Collection: "posts"
- Collection ID: `posts`

### 3. Collection Attributes (Fields):
Create the following attributes in your "posts" collection:

| Attribute Name | Type | Required | Default | Description |
|---------------|------|----------|---------|-------------|
| content | string | No | - | The text content of the post |
| imageId | string | No | - | Appwrite file ID for uploaded image |
| mediaUrl | string | No | - | Full URL to the image (will be generated) |
| timestamp | string | Yes | - | ISO 8601 timestamp (e.g., "2024-01-15T10:30:00.000Z") |
| userId | string | Yes | - | ID of the user who created the post |
| displayName | string | Yes | - | User's display name |
| profileImageUrl | string | No | - | URL to user's profile image |
| likes | integer | No | 0 | Number of likes |
| comments | integer | No | 0 | Number of comments |

### 4. Permissions:
Set appropriate permissions for the collection:
- Read: Any
- Write: Users

### 5. Storage Bucket Setup:
- Bucket ID: `68a7196f00082654543d` (already referenced in code)
- Make sure the bucket has proper permissions for file uploads

## Code Updates Needed:

The current implementation needs to be updated to include user information and generate proper image URLs:

1. **User Information**: The app needs to get the current user's ID, display name, and profile image URL
2. **Image URL Generation**: Need to convert `imageId` to a full media URL
3. **Default Values**: Set default values for likes and comments (0)

## Example Post Document Structure:
```json
{
  "content": "Hello everyone!",
  "imageId": "68a7196f00082654543d",
  "mediaUrl": "https://cloud.appwrite.io/v1/storage/buckets/68a7196f00082654543d/files/68a7196f00082654543d/view",
  "timestamp": "2024-01-15T10:30:00.000Z",
  "userId": "user123",
  "displayName": "John Doe",
  "profileImageUrl": "https://example.com/profile.jpg",
  "likes": 0,
  "comments": 0
}
```

## Next Steps:
1. Set up the Appwrite collection with the specified attributes
2. Update the Flutter code to include user information when creating posts
3. Implement user authentication to get current user details
4. Add functionality to generate proper image URLs from file IDs
