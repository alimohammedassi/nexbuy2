<<<<<<< HEAD
# 🔧 Fix: API Key Not Valid Error

## Problem
You're seeing the error: **"An internal error has occurred. [ API key not valid. Please pass a valid API key."**

This happens because `firebase_options.dart` contains placeholder values instead of your actual Firebase configuration.

## Solution

You have **two options** to fix this:

---

## Option 1: Use FlutterFire CLI (Recommended) ⭐

This is the easiest way to configure Firebase automatically:

### Steps:

1. **Install FlutterFire CLI** (if not already installed):
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Configure Firebase**:
   ```bash
   flutterfire configure
   ```

4. **Select your project** when prompted

5. **Select platforms** (Android, iOS, Web, etc.)

The CLI will automatically:
- ✅ Update `firebase_options.dart` with correct values
- ✅ Download `google-services.json` for Android
- ✅ Configure everything properly

---

## Option 2: Manual Configuration

If you prefer to configure manually:

### Step 1: Get Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Click ⚙️ (Settings) → **Project settings**
4. Scroll to **"Your apps"** section

### Step 2: Add Android App (if not already added)

1. Click **"Add app"** → Select **Android** icon
2. Enter package name: `com.example.nexbuy`
3. Click **"Register app"**
4. Download `google-services.json`
5. Place it in: `android/app/google-services.json`

### Step 3: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase values:

#### For Android:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',  // From google-services.json → api_key → current_key
  appId: 'YOUR_ACTUAL_APP_ID',    // From google-services.json → mobilesdk_app_id
  messagingSenderId: 'YOUR_PROJECT_NUMBER',  // From google-services.json → project_number
  projectId: 'YOUR_PROJECT_ID',   // From google-services.json → project_info → project_id
  storageBucket: 'YOUR_STORAGE_BUCKET',  // From google-services.json → project_info → storage_bucket
);
```

#### Where to find values in google-services.json:

```json
{
  "project_info": {
    "project_number": "247988235843",  // → messagingSenderId
    "project_id": "nexbuy-29c25",      // → projectId
    "storage_bucket": "nexbuy-29c25.appspot.com"  // → storageBucket
  },
  "client": [{
    "client_info": {
      "mobilesdk_app_id": "1:247988235843:android:fbb50230d2c69beda9eef6"  // → appId
    },
    "api_key": [{
      "current_key": "AIzaSyDaoRSeEDgLiEZjHO76xm2hjC12JJw_TqI"  // → apiKey
    }]
  }]
}
```

### Step 4: Rebuild the App

```bash
flutter clean
flutter pub get
flutter run
```

---

## Verify It's Working

After configuration, you should see in the console:
```
✅ Firebase initialized successfully
```

If you still see errors, check:
- ✅ `google-services.json` is in `android/app/`
- ✅ `firebase_options.dart` has real values (not `YOUR_*`)
- ✅ Package name matches: `com.example.nexbuy`
- ✅ Firebase project is active in Firebase Console

---

## Quick Test

After fixing, try:
1. **Email/Password Sign Up** - Should work now
2. **Email/Password Login** - Should work now
3. **Google Sign-In** - Should work (if SHA-1/SHA-256 are configured)

---

## Need Help?

If you're still getting errors:
1. Check the console output for specific error messages
2. Verify all values in `firebase_options.dart` are correct
3. Make sure `google-services.json` is in the right location
4. Try `flutter clean` and rebuild



























=======
# 🔧 Fix: API Key Not Valid Error

## Problem
You're seeing the error: **"An internal error has occurred. [ API key not valid. Please pass a valid API key."**

This happens because `firebase_options.dart` contains placeholder values instead of your actual Firebase configuration.

## Solution

You have **two options** to fix this:

---

## Option 1: Use FlutterFire CLI (Recommended) ⭐

This is the easiest way to configure Firebase automatically:

### Steps:

1. **Install FlutterFire CLI** (if not already installed):
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Configure Firebase**:
   ```bash
   flutterfire configure
   ```

4. **Select your project** when prompted

5. **Select platforms** (Android, iOS, Web, etc.)

The CLI will automatically:
- ✅ Update `firebase_options.dart` with correct values
- ✅ Download `google-services.json` for Android
- ✅ Configure everything properly

---

## Option 2: Manual Configuration

If you prefer to configure manually:

### Step 1: Get Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Click ⚙️ (Settings) → **Project settings**
4. Scroll to **"Your apps"** section

### Step 2: Add Android App (if not already added)

1. Click **"Add app"** → Select **Android** icon
2. Enter package name: `com.example.nexbuy`
3. Click **"Register app"**
4. Download `google-services.json`
5. Place it in: `android/app/google-services.json`

### Step 3: Update firebase_options.dart

Open `lib/firebase_options.dart` and replace the placeholder values with your actual Firebase values:

#### For Android:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',  // From google-services.json → api_key → current_key
  appId: 'YOUR_ACTUAL_APP_ID',    // From google-services.json → mobilesdk_app_id
  messagingSenderId: 'YOUR_PROJECT_NUMBER',  // From google-services.json → project_number
  projectId: 'YOUR_PROJECT_ID',   // From google-services.json → project_info → project_id
  storageBucket: 'YOUR_STORAGE_BUCKET',  // From google-services.json → project_info → storage_bucket
);
```

#### Where to find values in google-services.json:

```json
{
  "project_info": {
    "project_number": "247988235843",  // → messagingSenderId
    "project_id": "nexbuy-29c25",      // → projectId
    "storage_bucket": "nexbuy-29c25.appspot.com"  // → storageBucket
  },
  "client": [{
    "client_info": {
      "mobilesdk_app_id": "1:247988235843:android:fbb50230d2c69beda9eef6"  // → appId
    },
    "api_key": [{
      "current_key": "AIzaSyDaoRSeEDgLiEZjHO76xm2hjC12JJw_TqI"  // → apiKey
    }]
  }]
}
```

### Step 4: Rebuild the App

```bash
flutter clean
flutter pub get
flutter run
```

---

## Verify It's Working

After configuration, you should see in the console:
```
✅ Firebase initialized successfully
```

If you still see errors, check:
- ✅ `google-services.json` is in `android/app/`
- ✅ `firebase_options.dart` has real values (not `YOUR_*`)
- ✅ Package name matches: `com.example.nexbuy`
- ✅ Firebase project is active in Firebase Console

---

## Quick Test

After fixing, try:
1. **Email/Password Sign Up** - Should work now
2. **Email/Password Login** - Should work now
3. **Google Sign-In** - Should work (if SHA-1/SHA-256 are configured)

---

## Need Help?

If you're still getting errors:
1. Check the console output for specific error messages
2. Verify all values in `firebase_options.dart` are correct
3. Make sure `google-services.json` is in the right location
4. Try `flutter clean` and rebuild



























>>>>>>> 896380966d47b05a23f794163756ef8892357164
