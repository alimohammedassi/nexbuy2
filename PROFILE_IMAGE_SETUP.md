<<<<<<< HEAD
# 📸 Profile Image Setup Guide

## ✅ Implementation Complete!

Profile image functionality has been added to your app. Users can now:
- See their Google profile image automatically (if signed in with Google)
- Upload their own profile image (if signed in with email)
- See the image in both Profile Screen and Home Page Header

---

## 📋 What's Been Implemented

### ✅ Code Changes:

1. **Added image_picker package** (`pubspec.yaml`)
   - Allows users to select images from their gallery

2. **Updated User Service** (`lib/services/user_service.dart`)
   - Gets Google profile image from Supabase user metadata
   - Added `updateProfileImage()` method to save image URL
   - Added `uploadProfileImage()` method to upload to Supabase Storage

3. **Updated Profile Screen** (`lib/screens/profile_screen.dart`)
   - Displays user profile image from Supabase
   - Shows placeholder icon if no image

4. **Updated Edit Profile Screen** (`lib/screens/edit_profile_screen.dart`)
   - Added image picker functionality
   - Users can tap on profile image to select new one
   - Image is uploaded and saved when profile is updated

5. **Updated Home Page Header** (`lib/screens/home_screen.dart`)
   - Displays user profile image in the header
   - Shows placeholder if no image

6. **Added Android Permissions** (`android/app/src/main/AndroidManifest.xml`)
   - Added READ_EXTERNAL_STORAGE permission
   - Added READ_MEDIA_IMAGES permission (for Android 13+)

---

## 🚀 How It Works

### For Google Sign-In Users:
1. When user signs in with Google, their profile image is automatically fetched
2. Image URL is stored in Supabase user metadata
3. Image appears automatically in Profile and Home Header

### For Email Sign-In Users:
1. User goes to Profile → Edit Profile
2. Taps on the profile image
3. Selects image from gallery
4. Image is uploaded to Supabase Storage
5. Image URL is saved in user metadata
6. Image appears in Profile and Home Header

---

## ⚙️ Supabase Storage Setup (Required)

To enable image uploads, you need to create a storage bucket in Supabase:

### Step 1: Create Storage Bucket

1. Go to Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: `oudcfgijvkxzawhaayia`
3. Go to **Storage** in the left sidebar
4. Click **New bucket**
5. Name: `avatars`
6. Make it **Public** (so images can be accessed)
7. Click **Create bucket**

### Step 2: Set Storage Policies

1. Click on the `avatars` bucket
2. Go to **Policies** tab
3. Add policy for uploads:
   - Policy name: `Allow authenticated uploads`
   - Allowed operation: `INSERT`
   - Target roles: `authenticated`
   - Policy definition:
     ```sql
     (bucket_id = 'avatars'::text) AND (auth.role() = 'authenticated'::text)
     ```

4. Add policy for reads:
   - Policy name: `Allow public reads`
   - Allowed operation: `SELECT`
   - Target roles: `public`
   - Policy definition:
     ```sql
     (bucket_id = 'avatars'::text)
     ```

---

## 🧪 Testing

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Test Google Sign-In:**
   - Sign in with Google
   - Check if your Google profile image appears in Profile and Home Header

3. **Test Image Upload:**
   - Go to Profile → Edit Profile
   - Tap on profile image
   - Select an image from gallery
   - Save profile
   - Check if image appears in Profile and Home Header

---

## 📝 Notes

- **Image Size:** Images are automatically resized to max 512x512 pixels
- **Image Quality:** Set to 85% for good quality and file size balance
- **Storage:** Images are stored in Supabase Storage bucket `avatars`
- **Fallback:** If no image, a placeholder icon is shown

---

## 🔧 Troubleshooting

### Issue: Image doesn't appear after upload
- **Solution:** Check if Supabase Storage bucket `avatars` exists and is public
- Check storage policies are set correctly

### Issue: Can't select image
- **Solution:** Check Android permissions are granted
- On Android 13+, the app will request permission automatically

### Issue: Google image doesn't show
- **Solution:** Google profile images are automatically fetched from Google OAuth
- Check if user signed in with Google (not email)

---

## ✨ You're All Set!

After setting up the Supabase Storage bucket, profile images will work perfectly!

=======
# 📸 Profile Image Setup Guide

## ✅ Implementation Complete!

Profile image functionality has been added to your app. Users can now:
- See their Google profile image automatically (if signed in with Google)
- Upload their own profile image (if signed in with email)
- See the image in both Profile Screen and Home Page Header

---

## 📋 What's Been Implemented

### ✅ Code Changes:

1. **Added image_picker package** (`pubspec.yaml`)
   - Allows users to select images from their gallery

2. **Updated User Service** (`lib/services/user_service.dart`)
   - Gets Google profile image from Supabase user metadata
   - Added `updateProfileImage()` method to save image URL
   - Added `uploadProfileImage()` method to upload to Supabase Storage

3. **Updated Profile Screen** (`lib/screens/profile_screen.dart`)
   - Displays user profile image from Supabase
   - Shows placeholder icon if no image

4. **Updated Edit Profile Screen** (`lib/screens/edit_profile_screen.dart`)
   - Added image picker functionality
   - Users can tap on profile image to select new one
   - Image is uploaded and saved when profile is updated

5. **Updated Home Page Header** (`lib/screens/home_screen.dart`)
   - Displays user profile image in the header
   - Shows placeholder if no image

6. **Added Android Permissions** (`android/app/src/main/AndroidManifest.xml`)
   - Added READ_EXTERNAL_STORAGE permission
   - Added READ_MEDIA_IMAGES permission (for Android 13+)

---

## 🚀 How It Works

### For Google Sign-In Users:
1. When user signs in with Google, their profile image is automatically fetched
2. Image URL is stored in Supabase user metadata
3. Image appears automatically in Profile and Home Header

### For Email Sign-In Users:
1. User goes to Profile → Edit Profile
2. Taps on the profile image
3. Selects image from gallery
4. Image is uploaded to Supabase Storage
5. Image URL is saved in user metadata
6. Image appears in Profile and Home Header

---

## ⚙️ Supabase Storage Setup (Required)

To enable image uploads, you need to create a storage bucket in Supabase:

### Step 1: Create Storage Bucket

1. Go to Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: `oudcfgijvkxzawhaayia`
3. Go to **Storage** in the left sidebar
4. Click **New bucket**
5. Name: `avatars`
6. Make it **Public** (so images can be accessed)
7. Click **Create bucket**

### Step 2: Set Storage Policies

1. Click on the `avatars` bucket
2. Go to **Policies** tab
3. Add policy for uploads:
   - Policy name: `Allow authenticated uploads`
   - Allowed operation: `INSERT`
   - Target roles: `authenticated`
   - Policy definition:
     ```sql
     (bucket_id = 'avatars'::text) AND (auth.role() = 'authenticated'::text)
     ```

4. Add policy for reads:
   - Policy name: `Allow public reads`
   - Allowed operation: `SELECT`
   - Target roles: `public`
   - Policy definition:
     ```sql
     (bucket_id = 'avatars'::text)
     ```

---

## 🧪 Testing

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Test Google Sign-In:**
   - Sign in with Google
   - Check if your Google profile image appears in Profile and Home Header

3. **Test Image Upload:**
   - Go to Profile → Edit Profile
   - Tap on profile image
   - Select an image from gallery
   - Save profile
   - Check if image appears in Profile and Home Header

---

## 📝 Notes

- **Image Size:** Images are automatically resized to max 512x512 pixels
- **Image Quality:** Set to 85% for good quality and file size balance
- **Storage:** Images are stored in Supabase Storage bucket `avatars`
- **Fallback:** If no image, a placeholder icon is shown

---

## 🔧 Troubleshooting

### Issue: Image doesn't appear after upload
- **Solution:** Check if Supabase Storage bucket `avatars` exists and is public
- Check storage policies are set correctly

### Issue: Can't select image
- **Solution:** Check Android permissions are granted
- On Android 13+, the app will request permission automatically

### Issue: Google image doesn't show
- **Solution:** Google profile images are automatically fetched from Google OAuth
- Check if user signed in with Google (not email)

---

## ✨ You're All Set!

After setting up the Supabase Storage bucket, profile images will work perfectly!

>>>>>>> 896380966d47b05a23f794163756ef8892357164
