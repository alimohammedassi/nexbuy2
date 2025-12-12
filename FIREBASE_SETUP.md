<<<<<<< HEAD
# Firebase Setup Guide for NexBuy

This guide will help you set up Firebase Authentication with Google Sign-In and Email/Password authentication for the NexBuy app.

## Prerequisites

1. A Firebase account (create one at https://firebase.google.com/)
2. Flutter SDK installed
3. FlutterFire CLI installed: `dart pub global activate flutterfire_cli`

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard to create your project
4. Enable Google Analytics (optional but recommended)

## Step 2: Configure Firebase for Android

1. In the Firebase Console, click "Add app" and select Android
2. Register your app with the package name: `com.example.nexbuy`
3. Download the `google-services.json` file
4. Place the `google-services.json` file in `android/app/` directory
5. The Android build configuration is already set up in the project

## Step 3: Configure Firebase for iOS

1. In the Firebase Console, click "Add app" and select iOS
2. Register your app with the bundle ID: `com.example.nexbuy`
3. Download the `GoogleService-Info.plist` file
4. Place the `GoogleService-Info.plist` file in `ios/Runner/` directory
5. Open `ios/Runner.xcworkspace` in Xcode
6. Right-click on the `Runner` folder and select "Add Files to Runner"
7. Select the `GoogleService-Info.plist` file and make sure "Copy items if needed" is checked

## Step 4: Enable Authentication Methods

1. In the Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Email/Password** authentication:
   - Click on "Email/Password"
   - Toggle "Enable" to ON
   - Click "Save"

3. Enable **Google** authentication:
   - Click on "Google"
   - Toggle "Enable" to ON
   - Set the project support email
   - Click "Save"

## Step 5: Configure Firebase Options (Alternative Method)

If you prefer to use FlutterFire CLI (recommended):

1. Run the following command in your project root:
   ```bash
   flutterfire configure
   ```

2. Select your Firebase project
3. Select the platforms you want to configure (Android, iOS, Web, etc.)
4. The CLI will automatically generate the `firebase_options.dart` file

**OR** manually configure by editing `lib/firebase_options.dart`:

1. Replace all `YOUR_*` placeholders with your actual Firebase configuration values
2. You can find these values in:
   - Firebase Console > Project Settings > Your apps
   - For Android: `google-services.json`
   - For iOS: `GoogleService-Info.plist`
   - For Web: Project Settings > General > Your apps

## Step 6: Install Dependencies

Run the following command to install all required packages:

```bash
flutter pub get
```

## Step 7: Configure Google Sign-In

### For Android:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Credentials**
4. Create an OAuth 2.0 Client ID for Android (if not already created)
5. Add your app's SHA-1 certificate fingerprint:
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy the SHA-1 fingerprint and add it to your Firebase project settings

### For iOS:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Credentials**
4. Create an OAuth 2.0 Client ID for iOS
5. Use your bundle ID: `com.example.nexbuy`

## Step 8: Set up Firestore Database (Optional but Recommended)

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development) or **production mode** (for production)
4. Select a location for your database
5. The app will automatically create user documents when users sign up

## Step 9: Test the Authentication

1. Run the app:
   ```bash
   flutter run
   ```

2. Test email/password sign-up:
   - Go to the signup screen
   - Enter name, email, and password
   - Click "Sign Up"
   - Check Firebase Console > Authentication to see the new user

3. Test Google Sign-In:
   - Click "Continue with Google"
   - Select a Google account
   - Verify the user is created in Firebase Console

4. Test password reset:
   - Go to the login screen
   - Click "Forgot Password?"
   - Enter an email
   - Check the email inbox for the reset link

## Troubleshooting

### Android Issues:

1. **Build errors**: Make sure `google-services.json` is in `android/app/`
2. **Google Sign-In not working**: Verify SHA-1 fingerprint is added to Firebase
3. **Plugin errors**: Run `flutter clean` and `flutter pub get`

### iOS Issues:

1. **Build errors**: Make sure `GoogleService-Info.plist` is added to Xcode project
2. **Google Sign-In not working**: Verify bundle ID matches Firebase configuration
3. **CocoaPods issues**: Run `cd ios && pod install && cd ..`

### Common Errors:

- **"FirebaseApp not initialized"**: Make sure Firebase is initialized in `main.dart`
- **"PlatformException"**: Check that platform-specific configuration files are in place
- **"Network error"**: Verify internet connection and Firebase project settings

## Security Rules for Firestore

Add these security rules to your Firestore database (Firebase Console > Firestore > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add more rules for other collections as needed
  }
}
```

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)
- [Google Sign-In Setup](https://firebase.google.com/docs/auth/android/google-signin)

## Notes

- The `firebase_options.dart` file contains placeholder values that need to be replaced with your actual Firebase configuration
- Make sure to keep your `google-services.json` and `GoogleService-Info.plist` files secure and never commit them to public repositories if they contain sensitive information
- For production, consider using environment variables or secure storage for Firebase configuration

=======
# Firebase Setup Guide for NexBuy

This guide will help you set up Firebase Authentication with Google Sign-In and Email/Password authentication for the NexBuy app.

## Prerequisites

1. A Firebase account (create one at https://firebase.google.com/)
2. Flutter SDK installed
3. FlutterFire CLI installed: `dart pub global activate flutterfire_cli`

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or select an existing project
3. Follow the setup wizard to create your project
4. Enable Google Analytics (optional but recommended)

## Step 2: Configure Firebase for Android

1. In the Firebase Console, click "Add app" and select Android
2. Register your app with the package name: `com.example.nexbuy`
3. Download the `google-services.json` file
4. Place the `google-services.json` file in `android/app/` directory
5. The Android build configuration is already set up in the project

## Step 3: Configure Firebase for iOS

1. In the Firebase Console, click "Add app" and select iOS
2. Register your app with the bundle ID: `com.example.nexbuy`
3. Download the `GoogleService-Info.plist` file
4. Place the `GoogleService-Info.plist` file in `ios/Runner/` directory
5. Open `ios/Runner.xcworkspace` in Xcode
6. Right-click on the `Runner` folder and select "Add Files to Runner"
7. Select the `GoogleService-Info.plist` file and make sure "Copy items if needed" is checked

## Step 4: Enable Authentication Methods

1. In the Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Email/Password** authentication:
   - Click on "Email/Password"
   - Toggle "Enable" to ON
   - Click "Save"

3. Enable **Google** authentication:
   - Click on "Google"
   - Toggle "Enable" to ON
   - Set the project support email
   - Click "Save"

## Step 5: Configure Firebase Options (Alternative Method)

If you prefer to use FlutterFire CLI (recommended):

1. Run the following command in your project root:
   ```bash
   flutterfire configure
   ```

2. Select your Firebase project
3. Select the platforms you want to configure (Android, iOS, Web, etc.)
4. The CLI will automatically generate the `firebase_options.dart` file

**OR** manually configure by editing `lib/firebase_options.dart`:

1. Replace all `YOUR_*` placeholders with your actual Firebase configuration values
2. You can find these values in:
   - Firebase Console > Project Settings > Your apps
   - For Android: `google-services.json`
   - For iOS: `GoogleService-Info.plist`
   - For Web: Project Settings > General > Your apps

## Step 6: Install Dependencies

Run the following command to install all required packages:

```bash
flutter pub get
```

## Step 7: Configure Google Sign-In

### For Android:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Credentials**
4. Create an OAuth 2.0 Client ID for Android (if not already created)
5. Add your app's SHA-1 certificate fingerprint:
   ```bash
   # For debug keystore
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
6. Copy the SHA-1 fingerprint and add it to your Firebase project settings

### For iOS:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Credentials**
4. Create an OAuth 2.0 Client ID for iOS
5. Use your bundle ID: `com.example.nexbuy`

## Step 8: Set up Firestore Database (Optional but Recommended)

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Start in **test mode** (for development) or **production mode** (for production)
4. Select a location for your database
5. The app will automatically create user documents when users sign up

## Step 9: Test the Authentication

1. Run the app:
   ```bash
   flutter run
   ```

2. Test email/password sign-up:
   - Go to the signup screen
   - Enter name, email, and password
   - Click "Sign Up"
   - Check Firebase Console > Authentication to see the new user

3. Test Google Sign-In:
   - Click "Continue with Google"
   - Select a Google account
   - Verify the user is created in Firebase Console

4. Test password reset:
   - Go to the login screen
   - Click "Forgot Password?"
   - Enter an email
   - Check the email inbox for the reset link

## Troubleshooting

### Android Issues:

1. **Build errors**: Make sure `google-services.json` is in `android/app/`
2. **Google Sign-In not working**: Verify SHA-1 fingerprint is added to Firebase
3. **Plugin errors**: Run `flutter clean` and `flutter pub get`

### iOS Issues:

1. **Build errors**: Make sure `GoogleService-Info.plist` is added to Xcode project
2. **Google Sign-In not working**: Verify bundle ID matches Firebase configuration
3. **CocoaPods issues**: Run `cd ios && pod install && cd ..`

### Common Errors:

- **"FirebaseApp not initialized"**: Make sure Firebase is initialized in `main.dart`
- **"PlatformException"**: Check that platform-specific configuration files are in place
- **"Network error"**: Verify internet connection and Firebase project settings

## Security Rules for Firestore

Add these security rules to your Firestore database (Firebase Console > Firestore > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Add more rules for other collections as needed
  }
}
```

## Additional Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)
- [Google Sign-In Setup](https://firebase.google.com/docs/auth/android/google-signin)

## Notes

- The `firebase_options.dart` file contains placeholder values that need to be replaced with your actual Firebase configuration
- Make sure to keep your `google-services.json` and `GoogleService-Info.plist` files secure and never commit them to public repositories if they contain sensitive information
- For production, consider using environment variables or secure storage for Firebase configuration

>>>>>>> 896380966d47b05a23f794163756ef8892357164
