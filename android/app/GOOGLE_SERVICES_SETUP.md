# Google Services Setup

## ✅ Good News!

The build is now configured to work **without** `google-services.json`. The Google Services plugin will only be applied if the file exists.

## How to Enable Firebase (Optional):

If you want to use Firebase features (Google Sign-In, Firestore, etc.), you need to add the `google-services.json` file:

### Steps:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create a new one)
3. Click on the gear icon ⚙️ next to "Project Overview"
4. Select "Project settings"
5. Scroll down to "Your apps" section
6. If you don't have an Android app yet:
   - Click "Add app" → Select Android icon
   - Enter package name: `com.example.nexbuy`
   - Click "Register app"
7. Download the `google-services.json` file
8. Place it in `android/app/google-services.json`

### After Adding the File:

- The Google Services plugin will automatically be applied
- Firebase features will work in your app
- You can use Google Sign-In, Firestore, etc.

### Current Status:

- ✅ Build works without `google-services.json`
- ⚠️ Firebase features are disabled until you add the file
- 📝 See `lib/firebase_options.dart` for Firebase configuration

