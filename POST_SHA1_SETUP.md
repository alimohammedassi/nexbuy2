# What to Do After Adding SHA1 and SHA256

## ✅ You've Added SHA1 and SHA256 - Now What?

After adding your SHA1 and SHA256 fingerprints to Firebase, follow these steps:

---

## Step 1: Download Updated google-services.json

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Select your project

2. **Download Updated Configuration**
   - Go to **Project Settings** (⚙️ icon)
   - Scroll down to **Your apps** section
   - Find your Android app
   - Click **Download google-services.json**

3. **Replace the Old File**
   - Delete the old `google-services.json` from `android/app/`
   - Place the new `google-services.json` in `android/app/`
   - Make sure the file is named exactly `google-services.json`

---

## Step 2: Verify Firebase Configuration

1. **Check firebase_options.dart**
   - Open `lib/firebase_options.dart`
   - Make sure all values are filled (not placeholder values)
   - If you see `YOUR_*` placeholders, replace them with actual values from Firebase Console

2. **Verify google-services.json**
   - Open `android/app/google-services.json`
   - Check that `package_name` matches your app's package name
   - Verify `project_id` is correct

---

## Step 3: Test Google Sign-In

1. **Build and Run the App**
   ```powershell
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Google Sign-In**
   - Go to Login or Signup screen
   - Click "Continue with Google"
   - You should see Google Sign-In dialog
   - Select your Google account
   - Sign-in should work now!

3. **If Google Sign-In Still Doesn't Work:**
   - Wait 5-10 minutes (Firebase needs time to propagate changes)
   - Check Firebase Console → Authentication → Sign-in method
   - Make sure Google is enabled
   - Verify SHA1/SHA256 are correctly added

---

## Step 4: Test Firebase Authentication

1. **Test Email/Password Sign-Up**
   - Go to Signup screen
   - Enter name, email, and password
   - Click "Sign Up"
   - Check Firebase Console → Authentication → Users
   - You should see the new user

2. **Test Email/Password Sign-In**
   - Go to Login screen
   - Enter email and password
   - Click "Sign In"
   - Should navigate to home screen

3. **Test Password Reset**
   - Go to Login screen
   - Click "Forgot Password?"
   - Enter email
   - Check email inbox for reset link

---

## Step 5: Test Firestore (Admin Dashboard)

1. **Set Admin Status**
   - Go to Firebase Console → Firestore Database
   - Open `users` collection
   - Find your user document
   - Add field: `isAdmin` = `true` (boolean)

2. **Test Admin Dashboard**
   - Log in to the app
   - Go to Profile screen
   - You should see "Admin Dashboard" menu item
   - Tap it to open admin dashboard

3. **Test Adding Products**
   - In Admin Dashboard, go to "Add Product" tab
   - Fill in product details
   - Click "Add Product"
   - Check Firebase Console → Firestore → `products` collection
   - Product should appear there

4. **Test Viewing Products**
   - Go to "Products" tab in Admin Dashboard
   - You should see all products from Firestore

5. **Test Deleting Products**
   - Click delete icon on a product
   - Confirm deletion
   - Product should be removed from Firestore

---

## Step 6: Verify Everything Works

### ✅ Checklist:

- [ ] Google Sign-In works
- [ ] Email/Password sign-up works
- [ ] Email/Password sign-in works
- [ ] Password reset works
- [ ] User documents created in Firestore
- [ ] Admin dashboard accessible (if admin)
- [ ] Can add products to Firestore
- [ ] Can view products from Firestore
- [ ] Can delete products from Firestore
- [ ] No console errors

---

## Common Issues After Adding SHA1/SHA256

### Issue 1: Google Sign-In Still Not Working

**Solutions:**
- Wait 10-15 minutes for Firebase to update
- Restart the app completely
- Clear app data: `flutter clean` then rebuild
- Verify SHA1/SHA256 are correct in Firebase Console
- Check that Google Sign-In is enabled in Firebase Console

### Issue 2: "DEVELOPER_ERROR" or "10:" Error

**Solutions:**
- Make sure SHA1 is correct (not SHA256)
- Verify package name matches in Firebase Console
- Download new `google-services.json` after adding SHA1
- Rebuild the app: `flutter clean && flutter run`

### Issue 3: Firebase Not Initialized

**Solutions:**
- Check `firebase_options.dart` has correct values
- Verify `google-services.json` is in `android/app/`
- Check `main.dart` has Firebase initialization
- Look for errors in console

### Issue 4: Firestore Permission Denied

**Solutions:**
- Check Firestore security rules
- Make sure user is authenticated
- Verify Firestore is enabled in Firebase Console
- Check internet connection

---

## Step 7: Production Setup (Optional)

If you're preparing for production:

1. **Get Release SHA1**
   ```powershell
   keytool -list -v -keystore "path\to\your\release\keystore.jks" -alias your-alias
   ```

2. **Add Release SHA1 to Firebase**
   - Go to Firebase Console → Project Settings
   - Add the release SHA1 fingerprint
   - Download new `google-services.json`

3. **Update Security Rules**
   - Go to Firestore → Rules
   - Update rules for production
   - Test rules thoroughly

4. **Enable App Check** (Recommended)
   - Go to Firebase Console → App Check
   - Enable App Check for your app
   - This adds extra security

---

## Next Steps

1. **Test All Features**
   - Authentication (Email, Google)
   - Admin Dashboard
   - Product Management
   - User Profile
   - Cart and Favorites

2. **Monitor Firebase Console**
   - Check Authentication → Users
   - Check Firestore → Data
   - Monitor usage and errors

3. **Set Up Firestore Security Rules**
   - Go to Firestore → Rules
   - Implement proper security rules
   - Test rules in Rules Playground

4. **Optional: Set Up Analytics**
   - Enable Firebase Analytics
   - Track user behavior
   - Monitor app performance

---

## Summary

After adding SHA1 and SHA256:

1. ✅ Download new `google-services.json`
2. ✅ Replace old file in `android/app/`
3. ✅ Verify `firebase_options.dart` is configured
4. ✅ Test Google Sign-In
5. ✅ Test Email/Password authentication
6. ✅ Test Admin Dashboard
7. ✅ Test Firestore operations
8. ✅ Verify everything works

**That's it! Your Firebase integration should now be fully functional!** 🎉

---

## Need Help?

If you encounter issues:

1. Check Firebase Console for errors
2. Check Flutter console for error messages
3. Verify all configuration files are correct
4. Make sure internet connection is active
5. Try `flutter clean` and rebuild

---

## Important Notes

- **SHA1 vs SHA256**: Both are added for compatibility
- **Debug vs Release**: You may need different SHA1 for release builds
- **Propagation Time**: Firebase changes can take 5-15 minutes to take effect
- **Security**: Never commit `google-services.json` to public repositories if it contains sensitive data

