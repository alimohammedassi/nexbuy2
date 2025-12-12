<<<<<<< HEAD
# Admin Dashboard Setup Guide

This guide explains how to set up and use the Admin Dashboard for managing products in the NexBuy app.

## Features

The Admin Dashboard provides:
- **View all products** from Firestore database
- **Add new products** with full details
- **Delete products** from the database
- **Real-time updates** - product list updates automatically when changes are made

## Setup Instructions

### 1. Set Admin Status for a User

To give a user admin access, you need to set the `isAdmin` field to `true` in their Firestore user document.

#### Option A: Using Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Firestore Database**
4. Navigate to the `users` collection
5. Find the user document you want to make admin
6. Click on the document
7. Add a new field:
   - Field: `isAdmin`
   - Type: `boolean`
   - Value: `true`
8. Click **Update**

#### Option B: Using Code (One-time setup)

You can create a one-time script to set admin status. Add this to your app temporarily:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

Future<void> setAdminStatus() async {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final user = auth.currentUser;
  if (user != null) {
    await firestore.collection('users').doc(user.uid).update({
      'isAdmin': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('Admin status set for user: ${user.uid}');
  }
}
```

### 2. Access Admin Dashboard

1. Log in to the app with an admin account
2. Go to **Profile** screen
3. You'll see an **Admin Dashboard** menu item (purple icon)
4. Tap on it to open the admin dashboard

### 3. Firestore Security Rules

Update your Firestore security rules to allow admins to manage products:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Products collection - admins can read/write, users can only read
    match /products/{productId} {
      allow read: if request.auth != null;
      allow create, update, delete: if isAdmin();
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      // Allow admins to update any user's admin status
      allow update: if isAdmin();
    }
  }
}
```

### 4. Product Data Structure

Products are stored in Firestore with the following structure:

```json
{
  "id": "auto-generated-id",
  "name": "Product Name",
  "description": "Product description",
  "price": 999.99,
  "rating": 4.5,
  "imagePath": "images/product.jpg",
  "category": "Laptops",
  "isFavorite": false,
  "features": ["Feature 1", "Feature 2"],
  "brand": "Brand Name",
  "model": "Model Name",
  "specifications": {
    "Processor": "Intel i7",
    "Memory": "16GB",
    "Storage": "512GB SSD"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Using the Admin Dashboard

### Adding a Product

1. Open the Admin Dashboard
2. Go to the **Add Product** tab
3. Fill in all required fields:
   - Product Name
   - Description
   - Price
   - Rating (0-5)
   - Category
   - Brand
   - Model
   - Image Path
4. Add features:
   - Type a feature in the text field
   - Click the "+" button or press Enter
   - Features will appear as chips that can be deleted
5. Add specifications:
   - Enter a key (e.g., "Processor")
   - Enter a value (e.g., "Intel i7")
   - Click the "+" button or press Enter
   - Specifications will appear as removable items
6. Click **Add Product**
7. The product will be saved to Firestore and appear in the Products list

### Viewing Products

1. Open the Admin Dashboard
2. Go to the **Products** tab
3. You'll see a list of all products from Firestore
4. The list updates in real-time when products are added or deleted

### Deleting a Product

1. Open the Admin Dashboard
2. Go to the **Products** tab
3. Find the product you want to delete
4. Click the red delete icon on the product card
5. Confirm the deletion in the dialog
6. The product will be permanently deleted from Firestore

## Image Paths

When adding products, use image paths relative to the `assets` folder:

- Example: `images/product.jpg`
- The image should exist in your `assets/images/` folder
- Make sure the image is added to `pubspec.yaml` if it's in a subfolder

## Categories

Available categories (from CategoryProvider):
- Laptops
- Phones
- MacBooks
- Desktops
- Accessories
- Monitors

## Troubleshooting

### Admin Dashboard Not Showing

1. Check if the user has `isAdmin: true` in their Firestore user document
2. Make sure the user is logged in
3. Try logging out and logging back in
4. Check the console for any errors

### Cannot Add Products

1. Check Firestore security rules - admins should have write access
2. Check internet connection
3. Verify Firebase is properly initialized
4. Check console for error messages

### Products Not Showing

1. Check Firestore database - verify products exist in the `products` collection
2. Check Firestore security rules - users should have read access
3. Verify the app is connected to the correct Firebase project
4. Check console for any errors

### Delete Not Working

1. Check Firestore security rules - admins should have delete access
2. Verify the product ID is correct
3. Check console for error messages
4. Make sure you have admin privileges

## Security Notes

- Always protect admin routes with proper authentication
- Never expose admin functionality to regular users
- Use Firestore security rules to enforce access control
- Regularly audit admin users
- Use strong passwords for admin accounts
- Consider implementing 2FA for admin accounts

## Future Enhancements

Potential features to add:
- Edit existing products
- Bulk product import/export
- Product image upload to Firebase Storage
- Product analytics and statistics
- Order management
- User management
- Category management

=======
# Admin Dashboard Setup Guide

This guide explains how to set up and use the Admin Dashboard for managing products in the NexBuy app.

## Features

The Admin Dashboard provides:
- **View all products** from Firestore database
- **Add new products** with full details
- **Delete products** from the database
- **Real-time updates** - product list updates automatically when changes are made

## Setup Instructions

### 1. Set Admin Status for a User

To give a user admin access, you need to set the `isAdmin` field to `true` in their Firestore user document.

#### Option A: Using Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Firestore Database**
4. Navigate to the `users` collection
5. Find the user document you want to make admin
6. Click on the document
7. Add a new field:
   - Field: `isAdmin`
   - Type: `boolean`
   - Value: `true`
8. Click **Update**

#### Option B: Using Code (One-time setup)

You can create a one-time script to set admin status. Add this to your app temporarily:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

Future<void> setAdminStatus() async {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final user = auth.currentUser;
  if (user != null) {
    await firestore.collection('users').doc(user.uid).update({
      'isAdmin': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('Admin status set for user: ${user.uid}');
  }
}
```

### 2. Access Admin Dashboard

1. Log in to the app with an admin account
2. Go to **Profile** screen
3. You'll see an **Admin Dashboard** menu item (purple icon)
4. Tap on it to open the admin dashboard

### 3. Firestore Security Rules

Update your Firestore security rules to allow admins to manage products:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Products collection - admins can read/write, users can only read
    match /products/{productId} {
      allow read: if request.auth != null;
      allow create, update, delete: if isAdmin();
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      // Allow admins to update any user's admin status
      allow update: if isAdmin();
    }
  }
}
```

### 4. Product Data Structure

Products are stored in Firestore with the following structure:

```json
{
  "id": "auto-generated-id",
  "name": "Product Name",
  "description": "Product description",
  "price": 999.99,
  "rating": 4.5,
  "imagePath": "images/product.jpg",
  "category": "Laptops",
  "isFavorite": false,
  "features": ["Feature 1", "Feature 2"],
  "brand": "Brand Name",
  "model": "Model Name",
  "specifications": {
    "Processor": "Intel i7",
    "Memory": "16GB",
    "Storage": "512GB SSD"
  },
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Using the Admin Dashboard

### Adding a Product

1. Open the Admin Dashboard
2. Go to the **Add Product** tab
3. Fill in all required fields:
   - Product Name
   - Description
   - Price
   - Rating (0-5)
   - Category
   - Brand
   - Model
   - Image Path
4. Add features:
   - Type a feature in the text field
   - Click the "+" button or press Enter
   - Features will appear as chips that can be deleted
5. Add specifications:
   - Enter a key (e.g., "Processor")
   - Enter a value (e.g., "Intel i7")
   - Click the "+" button or press Enter
   - Specifications will appear as removable items
6. Click **Add Product**
7. The product will be saved to Firestore and appear in the Products list

### Viewing Products

1. Open the Admin Dashboard
2. Go to the **Products** tab
3. You'll see a list of all products from Firestore
4. The list updates in real-time when products are added or deleted

### Deleting a Product

1. Open the Admin Dashboard
2. Go to the **Products** tab
3. Find the product you want to delete
4. Click the red delete icon on the product card
5. Confirm the deletion in the dialog
6. The product will be permanently deleted from Firestore

## Image Paths

When adding products, use image paths relative to the `assets` folder:

- Example: `images/product.jpg`
- The image should exist in your `assets/images/` folder
- Make sure the image is added to `pubspec.yaml` if it's in a subfolder

## Categories

Available categories (from CategoryProvider):
- Laptops
- Phones
- MacBooks
- Desktops
- Accessories
- Monitors

## Troubleshooting

### Admin Dashboard Not Showing

1. Check if the user has `isAdmin: true` in their Firestore user document
2. Make sure the user is logged in
3. Try logging out and logging back in
4. Check the console for any errors

### Cannot Add Products

1. Check Firestore security rules - admins should have write access
2. Check internet connection
3. Verify Firebase is properly initialized
4. Check console for error messages

### Products Not Showing

1. Check Firestore database - verify products exist in the `products` collection
2. Check Firestore security rules - users should have read access
3. Verify the app is connected to the correct Firebase project
4. Check console for any errors

### Delete Not Working

1. Check Firestore security rules - admins should have delete access
2. Verify the product ID is correct
3. Check console for error messages
4. Make sure you have admin privileges

## Security Notes

- Always protect admin routes with proper authentication
- Never expose admin functionality to regular users
- Use Firestore security rules to enforce access control
- Regularly audit admin users
- Use strong passwords for admin accounts
- Consider implementing 2FA for admin accounts

## Future Enhancements

Potential features to add:
- Edit existing products
- Bulk product import/export
- Product image upload to Firebase Storage
- Product analytics and statistics
- Order management
- User management
- Category management

>>>>>>> 896380966d47b05a23f794163756ef8892357164
