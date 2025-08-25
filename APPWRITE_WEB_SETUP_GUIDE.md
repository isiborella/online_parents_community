# Appwrite Web Console Setup Guide

## Step-by-Step Instructions for Setting Up the Posts Collection

### 1. Access Your Appwrite Console
1. Go to: https://cloud.appwrite.io/
2. Login to your account
3. Select your project (Project ID: `68a714550022e0e26594`)

### 2. Create the Database
1. Navigate to **Database** in the left sidebar
2. Click **Create Database**
3. Fill in the details:
   - **Database ID**: `68a7209e0033e67e945c`
   - **Name**: `Parents Community`
4. Click **Create**

### 3. Create the Posts Collection
1. Inside your new database, click **Create Collection**
2. Fill in the details:
   - **Collection ID**: `posts`
   - **Name**: `Posts`
3. Set Permissions:
   - **Read Access**: `Any`
   - **Write Access**: `Users`
4. Click **Create**

### 4. Add Collection Attributes (Fields)

Add the following attributes one by one:

#### Attribute 1: content
- **Type**: String
- **Key**: `content`
- **Size**: `1000`
- **Required**: No
- **Default**: (leave empty)
- **Array**: No

#### Attribute 2: imageId
- **Type**: String
- **Key**: `imageId`
- **Size**: `255`
- **Required**: No
- **Default**: (leave empty)
- **Array**: No

#### Attribute 3: mediaUrl
- **Type**: String
- **Key**: `mediaUrl`
- **Size**: `500`
- **Required**: No
- **Default**: (leave empty)
- **Array**: No

#### Attribute 4: timestamp
- **Type**: String
- **Key**: `timestamp`
- **Size**: `255`
- **Required**: **Yes**
- **Default**: (leave empty)
- **Array**: No

#### Attribute 5: userId
- **Type**: String
- **Key**: `userId`
- **Size**: `255`
- **Required**: **Yes**
- **Default**: (leave empty)
- **Array**: No

#### Attribute 6: displayName
- **Type**: String
- **Key**: `displayName`
- **Size**: `255`
- **Required**: **Yes**
- **Default**: (leave empty)
- **Array**: No

#### Attribute 7: profileImageUrl
- **Type**: String
- **Key**: `profileImageUrl`
- **Size**: `500`
- **Required**: No
- **Default**: (leave empty)
- **Array**: No

#### Attribute 8: likes
- **Type**: Integer
- **Key**: `likes`
- **Min**: `0`
- **Max**: `10000`
- **Required**: No
- **Default**: `0`
- **Array**: No

#### Attribute 9: comments
- **Type**: Integer
- **Key**: `comments`
- **Min**: `0`
- **Max**: `10000`
- **Required**: No
- **Default**: `0`
- **Array**: No

### 5. Verify Storage Bucket (Optional)
Check if your storage bucket exists:
1. Go to **Storage** in the left sidebar
2. Look for bucket ID: `68a7196f00082654543d`
3. If it doesn't exist, create it:
   - **Bucket ID**: `68a7196f00082654543d`
   - **Name**: `Post Images`
   - **Permissions**: Read: Any, Write: Users
   - **File Security**: Enabled
   - **Encryption**: Enabled
   - **Antivirus**: Enabled

### 6. Test Your Setup
After completing the setup, your Flutter app should be able to:
- Create posts with text and images
- Display posts on the home page
- Handle user interactions (likes, comments)

### Troubleshooting Tips:
- Make sure all attribute keys match exactly as specified
- Verify permissions are set correctly (Read: Any, Write: Users)
- Check that the database and collection IDs match the code
- Ensure your Appwrite project endpoint is: `https://nyc.cloud.appwrite.io/v1`

Your app is now ready to create and display posts! 🎉
