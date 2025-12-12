<<<<<<< HEAD
# How to Access Admin Dashboard

## Step-by-Step Guide

### Step 1: Set Admin Status in Firestore

Before you can access the admin dashboard, you need to set your user account as an admin in Firestore.

#### Option A: Using Firebase Console (Recommended)

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project

2. **Navigate to Firestore Database**
   - Click on "Firestore Database" in the left menu
   - Make sure you're in the "Data" tab

3. **Find Your User Document**
   - Click on the `users` collection
   - Find your user document (it will have your user UID as the document ID)
   - If you don't see your user document, you need to sign up/login first

4. **Add Admin Field**
   - Click on your user document
   - Click "Add field" button
   - Field name: `isAdmin`
   - Field type: Select `boolean`
   - Field value: `true`
   - Click "Update"

5. **Verify**
   - Your user document should now have:
     ```json
     {
       "uid": "your-user-id",
       "email": "your-email@example.com",
       "name": "Your Name",
       "isAdmin": true,  // ← This field
       ...
     }
     ```

#### Option B: Using Code (Temporary Setup)

If you want to set admin status programmatically, you can add this code temporarily to your app:

```dart
// Add this to a button or run it once in your app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

Future<void> makeMeAdmin() async {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final user = auth.currentUser;
  if (user != null) {
    await firestore.collection('users').doc(user.uid).update({
      'isAdmin': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('✅ Admin status set for: ${user.email}');
  } else {
    print('❌ No user logged in');
  }
}
```

### Step 2: Log In to the App

1. **Open the NexBuy App**
   - Launch the app on your device/emulator

2. **Sign In**
   - Use the email/password account that you set as admin
   - OR sign in with Google (if that account is set as admin)

3. **Wait for Authentication**
   - Make sure you're successfully logged in
   - You should see the home screen

### Step 3: Navigate to Profile Screen

1. **Go to Profile Tab**
   - Look for the profile/user icon in the bottom navigation bar
   - Tap on it to open the Profile screen

2. **Scroll Down**
   - Scroll through the profile menu items
   - You should see various options like:
     - Edit Profile
     - Orders
     - Addresses
     - Payment Methods
     - Help Center
     - About
     - **Admin Dashboard** ← This should appear if you're admin

### Step 4: Access Admin Dashboard

1. **Look for Admin Dashboard Menu Item**
   - You should see a menu item with:
     - Purple gradient icon (admin panel icon)
     - Title: "Admin Dashboard"
     - Subtitle: "Manage products and settings"
   
2. **Tap on Admin Dashboard**
   - Tap the Admin Dashboard menu item
   - The dashboard will open

3. **Verify Access**
   - You should see two tabs:
     - **Products** tab: Shows all products
     - **Add Product** tab: Form to add new products

---

## Troubleshooting

### Problem: Admin Dashboard Menu Not Showing

**Possible Causes:**

1. **Admin Status Not Set**
   - Solution: Go back to Step 1 and verify `isAdmin: true` is set in Firestore

2. **User Not Logged In**
   - Solution: Make sure you're logged in with the correct account

3. **App Not Refreshed**
   - Solution: 
     - Log out and log back in
     - OR close and restart the app
     - OR pull down to refresh on the profile screen

4. **Wrong User Account**
   - Solution: Make sure the email you're logged in with matches the user document in Firestore

5. **Firestore Connection Issue**
   - Solution: Check internet connection and Firebase configuration

### Problem: "Access Denied" Message

**If you see "Access denied. Admin privileges required":**

1. **Check Firestore**
   - Verify `isAdmin: true` exists in your user document
   - Check that the field type is `boolean` (not `string`)

2. **Check User ID**
   - Make sure the UID in Firestore matches your logged-in user's UID
   - You can check your UID in the app or Firebase Console

3. **Try Again**
   - Close the app completely
   - Reopen and log in again
   - Navigate to profile screen

### Problem: Dashboard Opens But Shows "Access Denied"

**If dashboard opens but shows access denied screen:**

1. **Check Admin Service**
   - The admin service checks Firestore for `isAdmin: true`
   - Make sure the field exists and is `true`

2. **Check Internet Connection**
   - Firestore needs internet to check admin status
   - Verify your internet connection

3. **Check Firestore Rules**
   - Make sure Firestore security rules allow reading user documents
   - See `ADMIN_SETUP.md` for security rules

---

## Quick Check List

Before accessing admin dashboard, verify:

- [ ] User is logged in to the app
- [ ] User document exists in Firestore `users` collection
- [ ] `isAdmin` field exists in user document
- [ ] `isAdmin` field value is `true` (boolean, not string)
- [ ] App has internet connection
- [ ] Firebase is properly configured
- [ ] User has refreshed/logged out and back in after setting admin status

---

## Visual Guide

### In Firebase Console:

```
Firestore Database
  └── users (collection)
      └── [your-user-id] (document)
          ├── uid: "your-user-id"
          ├── email: "your@email.com"
          ├── name: "Your Name"
          ├── isAdmin: true  ← MUST BE TRUE
          └── ...
```

### In App:

```
Profile Screen
  └── Menu Items
      ├── Edit Profile
      ├── Orders
      ├── ...
      ├── Admin Dashboard  ← Should appear here
      │   └── (Purple icon)
      └── Sign Out
```

---

## Need Help?

If you're still having issues:

1. **Check Console Logs**
   - Look for error messages in the console
   - Check for Firestore connection errors

2. **Verify Firebase Setup**
   - Make sure Firebase is initialized in `main.dart`
   - Check `firebase_options.dart` has correct configuration
   - Verify `google-services.json` is in `android/app/`

3. **Test Admin Status Check**
   - You can temporarily add a print statement to check:
     ```dart
     final isAdmin = await AdminService().isAdmin();
     print('Is Admin: $isAdmin');
     ```

4. **Check Firestore Security Rules**
   - Make sure rules allow reading user documents
   - Rules should allow: `allow read: if request.auth != null;`

---

## Summary

**To access Admin Dashboard:**

1. ✅ Set `isAdmin: true` in your Firestore user document
2. ✅ Log in to the app with that user account
3. ✅ Go to Profile screen
4. ✅ Tap on "Admin Dashboard" menu item
5. ✅ Start managing products!

That's it! If you followed all steps and still can't access, check the troubleshooting section above.

=======
# How to Access Admin Dashboard

## Step-by-Step Guide

### Step 1: Set Admin Status in Firestore

Before you can access the admin dashboard, you need to set your user account as an admin in Firestore.

#### Option A: Using Firebase Console (Recommended)

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project

2. **Navigate to Firestore Database**
   - Click on "Firestore Database" in the left menu
   - Make sure you're in the "Data" tab

3. **Find Your User Document**
   - Click on the `users` collection
   - Find your user document (it will have your user UID as the document ID)
   - If you don't see your user document, you need to sign up/login first

4. **Add Admin Field**
   - Click on your user document
   - Click "Add field" button
   - Field name: `isAdmin`
   - Field type: Select `boolean`
   - Field value: `true`
   - Click "Update"

5. **Verify**
   - Your user document should now have:
     ```json
     {
       "uid": "your-user-id",
       "email": "your-email@example.com",
       "name": "Your Name",
       "isAdmin": true,  // ← This field
       ...
     }
     ```

#### Option B: Using Code (Temporary Setup)

If you want to set admin status programmatically, you can add this code temporarily to your app:

```dart
// Add this to a button or run it once in your app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

Future<void> makeMeAdmin() async {
  final firebase_auth.FirebaseAuth auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  final user = auth.currentUser;
  if (user != null) {
    await firestore.collection('users').doc(user.uid).update({
      'isAdmin': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    print('✅ Admin status set for: ${user.email}');
  } else {
    print('❌ No user logged in');
  }
}
```

### Step 2: Log In to the App

1. **Open the NexBuy App**
   - Launch the app on your device/emulator

2. **Sign In**
   - Use the email/password account that you set as admin
   - OR sign in with Google (if that account is set as admin)

3. **Wait for Authentication**
   - Make sure you're successfully logged in
   - You should see the home screen

### Step 3: Navigate to Profile Screen

1. **Go to Profile Tab**
   - Look for the profile/user icon in the bottom navigation bar
   - Tap on it to open the Profile screen

2. **Scroll Down**
   - Scroll through the profile menu items
   - You should see various options like:
     - Edit Profile
     - Orders
     - Addresses
     - Payment Methods
     - Help Center
     - About
     - **Admin Dashboard** ← This should appear if you're admin

### Step 4: Access Admin Dashboard

1. **Look for Admin Dashboard Menu Item**
   - You should see a menu item with:
     - Purple gradient icon (admin panel icon)
     - Title: "Admin Dashboard"
     - Subtitle: "Manage products and settings"
   
2. **Tap on Admin Dashboard**
   - Tap the Admin Dashboard menu item
   - The dashboard will open

3. **Verify Access**
   - You should see two tabs:
     - **Products** tab: Shows all products
     - **Add Product** tab: Form to add new products

---

## Troubleshooting

### Problem: Admin Dashboard Menu Not Showing

**Possible Causes:**

1. **Admin Status Not Set**
   - Solution: Go back to Step 1 and verify `isAdmin: true` is set in Firestore

2. **User Not Logged In**
   - Solution: Make sure you're logged in with the correct account

3. **App Not Refreshed**
   - Solution: 
     - Log out and log back in
     - OR close and restart the app
     - OR pull down to refresh on the profile screen

4. **Wrong User Account**
   - Solution: Make sure the email you're logged in with matches the user document in Firestore

5. **Firestore Connection Issue**
   - Solution: Check internet connection and Firebase configuration

### Problem: "Access Denied" Message

**If you see "Access denied. Admin privileges required":**

1. **Check Firestore**
   - Verify `isAdmin: true` exists in your user document
   - Check that the field type is `boolean` (not `string`)

2. **Check User ID**
   - Make sure the UID in Firestore matches your logged-in user's UID
   - You can check your UID in the app or Firebase Console

3. **Try Again**
   - Close the app completely
   - Reopen and log in again
   - Navigate to profile screen

### Problem: Dashboard Opens But Shows "Access Denied"

**If dashboard opens but shows access denied screen:**

1. **Check Admin Service**
   - The admin service checks Firestore for `isAdmin: true`
   - Make sure the field exists and is `true`

2. **Check Internet Connection**
   - Firestore needs internet to check admin status
   - Verify your internet connection

3. **Check Firestore Rules**
   - Make sure Firestore security rules allow reading user documents
   - See `ADMIN_SETUP.md` for security rules

---

## Quick Check List

Before accessing admin dashboard, verify:

- [ ] User is logged in to the app
- [ ] User document exists in Firestore `users` collection
- [ ] `isAdmin` field exists in user document
- [ ] `isAdmin` field value is `true` (boolean, not string)
- [ ] App has internet connection
- [ ] Firebase is properly configured
- [ ] User has refreshed/logged out and back in after setting admin status

---

## Visual Guide

### In Firebase Console:

```
Firestore Database
  └── users (collection)
      └── [your-user-id] (document)
          ├── uid: "your-user-id"
          ├── email: "your@email.com"
          ├── name: "Your Name"
          ├── isAdmin: true  ← MUST BE TRUE
          └── ...
```

### In App:

```
Profile Screen
  └── Menu Items
      ├── Edit Profile
      ├── Orders
      ├── ...
      ├── Admin Dashboard  ← Should appear here
      │   └── (Purple icon)
      └── Sign Out
```

---

## Need Help?

If you're still having issues:

1. **Check Console Logs**
   - Look for error messages in the console
   - Check for Firestore connection errors

2. **Verify Firebase Setup**
   - Make sure Firebase is initialized in `main.dart`
   - Check `firebase_options.dart` has correct configuration
   - Verify `google-services.json` is in `android/app/`

3. **Test Admin Status Check**
   - You can temporarily add a print statement to check:
     ```dart
     final isAdmin = await AdminService().isAdmin();
     print('Is Admin: $isAdmin');
     ```

4. **Check Firestore Security Rules**
   - Make sure rules allow reading user documents
   - Rules should allow: `allow read: if request.auth != null;`

---

## Summary

**To access Admin Dashboard:**

1. ✅ Set `isAdmin: true` in your Firestore user document
2. ✅ Log in to the app with that user account
3. ✅ Go to Profile screen
4. ✅ Tap on "Admin Dashboard" menu item
5. ✅ Start managing products!

That's it! If you followed all steps and still can't access, check the troubleshooting section above.

>>>>>>> 896380966d47b05a23f794163756ef8892357164
