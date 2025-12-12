<<<<<<< HEAD
# 🔐 Supabase Google Authentication Setup Guide

## ✅ Implementation Complete!

Google authentication has been successfully integrated into your Flutter app using Supabase. All the code is ready - you just need to configure it in your Supabase dashboard.

---

## 📋 Step-by-Step Supabase Configuration

### Step 1: Enable Google Provider in Supabase

1. **Go to Supabase Dashboard:**
   - Visit: https://supabase.com/dashboard
   - Select your project: `oudcfgijvkxzawhaayia`

2. **Navigate to Authentication:**
   - Click on **Authentication** in the left sidebar
   - Click on **Providers** tab

3. **Enable Google:**
   - Find **Google** in the list of providers
   - Click on it to open settings
   - Toggle **Enable Google provider** to ON

4. **Configure Google OAuth:**
   - You'll need to create a Google OAuth application:
     - Go to [Google Cloud Console](https://console.cloud.google.com/)
     - Create a new project or select existing one
     - Enable Google+ API
     - Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
     - Application type: **Web application**
     - Authorized redirect URIs: Add your Supabase redirect URL
       - Format: `https://[your-project-ref].supabase.co/auth/v1/callback`
       - Example: `https://oudcfgijvkxzawhaayia.supabase.co/auth/v1/callback`
     - Copy the **Client ID** and **Client Secret**

5. **Add Credentials to Supabase:**
   - Back in Supabase dashboard
   - Paste your **Client ID** and **Client Secret** from Google
   - Click **Save**

### Step 2: Configure Redirect URLs

1. **In Supabase Dashboard:**
   - Go to **Authentication** → **URL Configuration**
   - Under **Redirect URLs**, add:
     ```
     com.example.nexbuy://login-callback/
     ```
   - Click **Save**

### Step 3: Verify Deep Link Configuration

The Android manifest has been configured with the deep link:
- **Scheme:** `com.example.nexbuy`
- **Host:** `login-callback`

This matches the redirect URL in your auth service.

---

## 🎯 What's Been Implemented

### ✅ Code Changes Made:

1. **Supabase Initialization** (`lib/main.dart`)
   - Supabase is now initialized on app startup
   - Configured with PKCE auth flow for security

2. **Auth Service** (`lib/services/auth_service.dart`)
   - Updated `signInWithGoogle()` method
   - Uses correct redirect URL: `com.example.nexbuy://login-callback/`
   - Configured for external browser OAuth flow

3. **Login Screen** (`lib/screens/login_screen.dart`)
   - Google sign-in button now calls the auth service
   - Shows loading state during authentication
   - Displays error messages if sign-in fails

4. **Signup Screen** (`lib/screens/signup_screen.dart`)
   - Google sign-in button now calls the auth service
   - Shows loading state during authentication
   - Displays error messages if sign-in fails

5. **Splash Screen** (`lib/screens/splash_screen.dart`)
   - Checks authentication state on startup
   - Automatically navigates to home if user is logged in
   - Listens to auth state changes

6. **Android Manifest** (`android/app/src/main/AndroidManifest.xml`)
   - Added deep link intent filter for OAuth callback
   - Handles `com.example.nexbuy://login-callback/` URLs

---

## 🚀 How It Works

1. **User taps "Continue with Google"**
   - App calls `AuthService.signInWithGoogle()`
   - Supabase opens external browser for Google OAuth

2. **User authenticates with Google**
   - User selects Google account
   - Grants permissions
   - Google redirects back to Supabase

3. **Supabase redirects to app**
   - Supabase redirects to deep link: `com.example.nexbuy://login-callback/`
   - Android opens the app via deep link
   - Supabase SDK handles the callback automatically

4. **App receives auth state**
   - Splash screen listens to auth state changes
   - When session is detected, navigates to home screen
   - User is now logged in!

---

## 🧪 Testing

1. **Run the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Google Sign-In:**
   - Navigate to login or signup screen
   - Tap "Continue with Google"
   - Should open browser for Google authentication
   - After signing in, should redirect back to app
   - Should navigate to home screen automatically

---

## ⚠️ Troubleshooting

### Issue: "Redirect URL mismatch"
- **Solution:** Make sure the redirect URL in Supabase matches exactly:
  - `com.example.nexbuy://login-callback/`
  - Check both in Supabase dashboard and in `auth_service.dart`

### Issue: "Google OAuth error"
- **Solution:** 
  - Verify Google OAuth credentials are correct in Supabase
  - Check that redirect URI in Google Cloud Console includes Supabase callback URL
  - Ensure Google+ API is enabled

### Issue: "Deep link not working"
- **Solution:**
  - Verify Android manifest has the intent filter (already added)
  - Try uninstalling and reinstalling the app
  - Check that package name matches: `com.example.nexbuy`

### Issue: "App doesn't navigate after sign-in"
- **Solution:**
  - Check that splash screen is listening to auth state changes
  - Verify Supabase initialization in `main.dart`
  - Check console for any error messages

---

## 📝 Next Steps

After configuring Google auth in Supabase:

1. ✅ Test the authentication flow
2. ✅ Verify user data is stored in Supabase
3. ✅ Check that user session persists after app restart
4. ✅ Test sign-out functionality (if needed)

---

## 🔗 Useful Links

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google OAuth Setup](https://developers.google.com/identity/protocols/oauth2)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)

---

## ✨ You're All Set!

Once you've completed the Supabase configuration steps above, Google authentication will be fully functional in your app!

=======
# 🔐 Supabase Google Authentication Setup Guide

## ✅ Implementation Complete!

Google authentication has been successfully integrated into your Flutter app using Supabase. All the code is ready - you just need to configure it in your Supabase dashboard.

---

## 📋 Step-by-Step Supabase Configuration

### Step 1: Enable Google Provider in Supabase

1. **Go to Supabase Dashboard:**
   - Visit: https://supabase.com/dashboard
   - Select your project: `oudcfgijvkxzawhaayia`

2. **Navigate to Authentication:**
   - Click on **Authentication** in the left sidebar
   - Click on **Providers** tab

3. **Enable Google:**
   - Find **Google** in the list of providers
   - Click on it to open settings
   - Toggle **Enable Google provider** to ON

4. **Configure Google OAuth:**
   - You'll need to create a Google OAuth application:
     - Go to [Google Cloud Console](https://console.cloud.google.com/)
     - Create a new project or select existing one
     - Enable Google+ API
     - Go to **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
     - Application type: **Web application**
     - Authorized redirect URIs: Add your Supabase redirect URL
       - Format: `https://[your-project-ref].supabase.co/auth/v1/callback`
       - Example: `https://oudcfgijvkxzawhaayia.supabase.co/auth/v1/callback`
     - Copy the **Client ID** and **Client Secret**

5. **Add Credentials to Supabase:**
   - Back in Supabase dashboard
   - Paste your **Client ID** and **Client Secret** from Google
   - Click **Save**

### Step 2: Configure Redirect URLs

1. **In Supabase Dashboard:**
   - Go to **Authentication** → **URL Configuration**
   - Under **Redirect URLs**, add:
     ```
     com.example.nexbuy://login-callback/
     ```
   - Click **Save**

### Step 3: Verify Deep Link Configuration

The Android manifest has been configured with the deep link:
- **Scheme:** `com.example.nexbuy`
- **Host:** `login-callback`

This matches the redirect URL in your auth service.

---

## 🎯 What's Been Implemented

### ✅ Code Changes Made:

1. **Supabase Initialization** (`lib/main.dart`)
   - Supabase is now initialized on app startup
   - Configured with PKCE auth flow for security

2. **Auth Service** (`lib/services/auth_service.dart`)
   - Updated `signInWithGoogle()` method
   - Uses correct redirect URL: `com.example.nexbuy://login-callback/`
   - Configured for external browser OAuth flow

3. **Login Screen** (`lib/screens/login_screen.dart`)
   - Google sign-in button now calls the auth service
   - Shows loading state during authentication
   - Displays error messages if sign-in fails

4. **Signup Screen** (`lib/screens/signup_screen.dart`)
   - Google sign-in button now calls the auth service
   - Shows loading state during authentication
   - Displays error messages if sign-in fails

5. **Splash Screen** (`lib/screens/splash_screen.dart`)
   - Checks authentication state on startup
   - Automatically navigates to home if user is logged in
   - Listens to auth state changes

6. **Android Manifest** (`android/app/src/main/AndroidManifest.xml`)
   - Added deep link intent filter for OAuth callback
   - Handles `com.example.nexbuy://login-callback/` URLs

---

## 🚀 How It Works

1. **User taps "Continue with Google"**
   - App calls `AuthService.signInWithGoogle()`
   - Supabase opens external browser for Google OAuth

2. **User authenticates with Google**
   - User selects Google account
   - Grants permissions
   - Google redirects back to Supabase

3. **Supabase redirects to app**
   - Supabase redirects to deep link: `com.example.nexbuy://login-callback/`
   - Android opens the app via deep link
   - Supabase SDK handles the callback automatically

4. **App receives auth state**
   - Splash screen listens to auth state changes
   - When session is detected, navigates to home screen
   - User is now logged in!

---

## 🧪 Testing

1. **Run the app:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Google Sign-In:**
   - Navigate to login or signup screen
   - Tap "Continue with Google"
   - Should open browser for Google authentication
   - After signing in, should redirect back to app
   - Should navigate to home screen automatically

---

## ⚠️ Troubleshooting

### Issue: "Redirect URL mismatch"
- **Solution:** Make sure the redirect URL in Supabase matches exactly:
  - `com.example.nexbuy://login-callback/`
  - Check both in Supabase dashboard and in `auth_service.dart`

### Issue: "Google OAuth error"
- **Solution:** 
  - Verify Google OAuth credentials are correct in Supabase
  - Check that redirect URI in Google Cloud Console includes Supabase callback URL
  - Ensure Google+ API is enabled

### Issue: "Deep link not working"
- **Solution:**
  - Verify Android manifest has the intent filter (already added)
  - Try uninstalling and reinstalling the app
  - Check that package name matches: `com.example.nexbuy`

### Issue: "App doesn't navigate after sign-in"
- **Solution:**
  - Check that splash screen is listening to auth state changes
  - Verify Supabase initialization in `main.dart`
  - Check console for any error messages

---

## 📝 Next Steps

After configuring Google auth in Supabase:

1. ✅ Test the authentication flow
2. ✅ Verify user data is stored in Supabase
3. ✅ Check that user session persists after app restart
4. ✅ Test sign-out functionality (if needed)

---

## 🔗 Useful Links

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google OAuth Setup](https://developers.google.com/identity/protocols/oauth2)
- [Supabase Flutter Documentation](https://supabase.com/docs/reference/dart/introduction)

---

## ✨ You're All Set!

Once you've completed the Supabase configuration steps above, Google authentication will be fully functional in your app!

>>>>>>> 896380966d47b05a23f794163756ef8892357164
