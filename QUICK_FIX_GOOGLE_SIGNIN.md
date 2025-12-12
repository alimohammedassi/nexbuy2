<<<<<<< HEAD
# 🚀 Quick Fix for Google Sign-In Error 12500

## ✅ Good News!
The error message is now showing correctly with helpful instructions. Now let's fix the actual configuration issue.

## 📋 Step-by-Step Fix

### Step 1: Get Your SHA-1 and SHA-256 Fingerprints

Run this command in PowerShell:
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Look for:**
- `SHA1: XX:XX:XX:...` (copy this)
- `SHA256: XX:XX:XX:...` (copy this)

### Step 2: Add Fingerprints to Firebase Console

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/
   - Select project: **nexbuy-29c25**

2. **Navigate to Project Settings:**
   - Click ⚙️ (Settings) → **Project settings**
   - Scroll to **Your apps** section
   - Click on your **Android app** (package: com.example.nexbuy)

3. **Add Fingerprints:**
   - Click **Add fingerprint** button
   - Paste your **SHA-1** fingerprint
   - Click **Add fingerprint** again
   - Paste your **SHA-256** fingerprint
   - Click **Save**

### Step 3: Download Updated google-services.json

1. **In Firebase Console:**
   - After adding fingerprints, click **Download google-services.json**
   - This file will have updated OAuth configuration

2. **Replace the file:**
   - Delete: `android/app/google-services.json`
   - Place the new file in: `android/app/google-services.json`

### Step 4: Verify Package Name

**Check these match exactly:**
- `android/app/build.gradle.kts`: `applicationId = "com.example.nexbuy"`
- `google-services.json`: `"package_name": "com.example.nexbuy"`

### Step 5: Enable Google Sign-In in Firebase

1. **In Firebase Console:**
   - Go to **Authentication** → **Sign-in method**
   - Find **Google** in the list
   - Click on it
   - Toggle **Enable** to ON
   - Click **Save**

### Step 6: Clean and Rebuild

```powershell
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## ✅ Verification Checklist

After completing the steps above, verify:

- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] SHA-256 fingerprint added to Firebase Console
- [ ] New `google-services.json` downloaded and placed in `android/app/`
- [ ] Package name matches: `com.example.nexbuy` (in both places)
- [ ] Google Sign-In enabled in Firebase Console
- [ ] App cleaned and rebuilt

## 🔍 Quick Verification Commands

**Check your fingerprints:**
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Check package name:**
```powershell
# In android/app/build.gradle.kts, look for:
# applicationId = "com.example.nexbuy"
```

**Check google-services.json:**
```powershell
# Open android/app/google-services.json
# Look for: "package_name": "com.example.nexbuy"
```

## 🎯 Expected Result

After completing all steps:
- ✅ Google Sign-In button should work
- ✅ No more error 12500
- ✅ Users can sign in with Google accounts
- ✅ Success message appears

## 🆘 Still Having Issues?

### Issue: "Fingerprints not found"
- Make sure you're using the correct keystore path
- For debug builds, use: `$env:USERPROFILE\.android\debug.keystore`
- For release builds, use your release keystore

### Issue: "Package name mismatch"
- Check `android/app/build.gradle.kts`: `applicationId`
- Check `google-services.json`: `package_name`
- They must be **exactly** the same (case-sensitive)

### Issue: "OAuth client not configured"
- Go to Google Cloud Console
- Select project: **nexbuy-29c25**
- Go to **APIs & Services** → **Credentials**
- Verify OAuth 2.0 Client IDs exist
- If missing, Firebase will create them automatically when you enable Google Sign-In

## 📝 Notes

- **Wait 5-10 minutes** after adding fingerprints before testing
- **Restart the app** completely after updating `google-services.json`
- **Use debug keystore** for development, release keystore for production
- **Both SHA-1 and SHA-256** are required for modern Android apps

## 🎉 Success!

Once all steps are completed, Google Sign-In should work perfectly!



























=======
# 🚀 Quick Fix for Google Sign-In Error 12500

## ✅ Good News!
The error message is now showing correctly with helpful instructions. Now let's fix the actual configuration issue.

## 📋 Step-by-Step Fix

### Step 1: Get Your SHA-1 and SHA-256 Fingerprints

Run this command in PowerShell:
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Look for:**
- `SHA1: XX:XX:XX:...` (copy this)
- `SHA256: XX:XX:XX:...` (copy this)

### Step 2: Add Fingerprints to Firebase Console

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/
   - Select project: **nexbuy-29c25**

2. **Navigate to Project Settings:**
   - Click ⚙️ (Settings) → **Project settings**
   - Scroll to **Your apps** section
   - Click on your **Android app** (package: com.example.nexbuy)

3. **Add Fingerprints:**
   - Click **Add fingerprint** button
   - Paste your **SHA-1** fingerprint
   - Click **Add fingerprint** again
   - Paste your **SHA-256** fingerprint
   - Click **Save**

### Step 3: Download Updated google-services.json

1. **In Firebase Console:**
   - After adding fingerprints, click **Download google-services.json**
   - This file will have updated OAuth configuration

2. **Replace the file:**
   - Delete: `android/app/google-services.json`
   - Place the new file in: `android/app/google-services.json`

### Step 4: Verify Package Name

**Check these match exactly:**
- `android/app/build.gradle.kts`: `applicationId = "com.example.nexbuy"`
- `google-services.json`: `"package_name": "com.example.nexbuy"`

### Step 5: Enable Google Sign-In in Firebase

1. **In Firebase Console:**
   - Go to **Authentication** → **Sign-in method**
   - Find **Google** in the list
   - Click on it
   - Toggle **Enable** to ON
   - Click **Save**

### Step 6: Clean and Rebuild

```powershell
flutter clean
flutter pub get
cd android
./gradlew clean
cd ..
flutter run
```

## ✅ Verification Checklist

After completing the steps above, verify:

- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] SHA-256 fingerprint added to Firebase Console
- [ ] New `google-services.json` downloaded and placed in `android/app/`
- [ ] Package name matches: `com.example.nexbuy` (in both places)
- [ ] Google Sign-In enabled in Firebase Console
- [ ] App cleaned and rebuilt

## 🔍 Quick Verification Commands

**Check your fingerprints:**
```powershell
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Check package name:**
```powershell
# In android/app/build.gradle.kts, look for:
# applicationId = "com.example.nexbuy"
```

**Check google-services.json:**
```powershell
# Open android/app/google-services.json
# Look for: "package_name": "com.example.nexbuy"
```

## 🎯 Expected Result

After completing all steps:
- ✅ Google Sign-In button should work
- ✅ No more error 12500
- ✅ Users can sign in with Google accounts
- ✅ Success message appears

## 🆘 Still Having Issues?

### Issue: "Fingerprints not found"
- Make sure you're using the correct keystore path
- For debug builds, use: `$env:USERPROFILE\.android\debug.keystore`
- For release builds, use your release keystore

### Issue: "Package name mismatch"
- Check `android/app/build.gradle.kts`: `applicationId`
- Check `google-services.json`: `package_name`
- They must be **exactly** the same (case-sensitive)

### Issue: "OAuth client not configured"
- Go to Google Cloud Console
- Select project: **nexbuy-29c25**
- Go to **APIs & Services** → **Credentials**
- Verify OAuth 2.0 Client IDs exist
- If missing, Firebase will create them automatically when you enable Google Sign-In

## 📝 Notes

- **Wait 5-10 minutes** after adding fingerprints before testing
- **Restart the app** completely after updating `google-services.json`
- **Use debug keystore** for development, release keystore for production
- **Both SHA-1 and SHA-256** are required for modern Android apps

## 🎉 Success!

Once all steps are completed, Google Sign-In should work perfectly!



























>>>>>>> 896380966d47b05a23f794163756ef8892357164
