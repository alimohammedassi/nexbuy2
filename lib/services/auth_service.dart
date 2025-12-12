import 'package:supabase_flutter/supabase_flutter.dart';

/// Authentication service for handling authentication with Supabase
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Check if user is logged in
  bool get isLoggedIn => _supabase.auth.currentUser != null;

  /// Sign in with Google
  /// Note: OAuth flow will redirect, user will be available after callback
  Future<void> signInWithGoogle() async {
    try {
      // For mobile, we can use the deep link directly in redirectTo
      // Supabase will handle the redirect even if validation shows error
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.nexbuy://login-callback',
        authScreenLaunchMode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Sign in with email and password
  Future<Session> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      return response.session!;
    } catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  /// Sign up with email and password
  /// Sends OTP code to email for verification
  /// Returns email for verification screen
  /// TODO: Re-enable email verification after testing
  Future<String> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Sign up user - this will send OTP code to email
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: name != null ? {'name': name, 'full_name': name} : null,
      );
      
      // If user is created and we have a name, update user metadata
      if (response.user != null && name != null && name.isNotEmpty) {
        try {
          // Update user metadata with name
          await _supabase.auth.updateUser(
            UserAttributes(
              data: {
                'name': name,
                'full_name': name,
              },
            ),
          );
          
          // Refresh user to get updated metadata
          await _supabase.auth.refreshSession();
        } catch (e) {
          // If update fails, continue anyway - user is still created
          print('Warning: Could not update user metadata: $e');
        }
      }
      
      // TEMPORARILY DISABLED: Email verification
      // If email confirmation is disabled in Supabase, user will have a session
      // and can log in immediately
      // if (response.session != null) {
      //   // User is automatically logged in (email confirmation disabled)
      //   return email.trim(); // Still return email, but session exists
      // }
      
      // Return email for verification screen
      return email.trim();
    } catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  /// Verify OTP code sent to email
  Future<Session> verifyEmailOTP({
    required String email,
    required String token,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email.trim(),
        token: token.trim(),
      );
      
      if (response.session == null) {
        throw Exception('Verification failed. Please check your code and try again.');
      }
      
      return response.session!;
    } catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  /// Resend OTP code to email
  Future<void> resendOTP(String email) async {
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email.trim(),
      );
    } catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }


  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
    } catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  /// Handle authentication exceptions
  String _handleAuthException(dynamic e) {
    // Try to extract the actual error message from Supabase
    String errorMessage = e.toString();
    
    // Check if it's a Supabase AuthException
    if (e is AuthException) {
      errorMessage = e.message;
    }
    
    final lowerMessage = errorMessage.toLowerCase();
    
    if (lowerMessage.contains('invalid login') || lowerMessage.contains('invalid credentials')) {
      return 'Invalid email or password.';
    } else if (lowerMessage.contains('email not confirmed') || lowerMessage.contains('email_not_confirmed')) {
      return 'Please verify your email address.';
    } else if (lowerMessage.contains('user already registered') || lowerMessage.contains('already registered') || lowerMessage.contains('user_exists')) {
      return 'An account already exists for that email.';
    } else if (lowerMessage.contains('password') && lowerMessage.contains('weak')) {
      return 'The password provided is too weak.';
    } else if (lowerMessage.contains('email') && lowerMessage.contains('invalid')) {
      return 'The email address is invalid. Please check your email format.';
    } else if (lowerMessage.contains('email') && lowerMessage.contains('format')) {
      return 'Invalid email format. Please enter a valid email address.';
    } else if (lowerMessage.contains('too many requests') || lowerMessage.contains('rate limit')) {
      return 'Too many requests. Please try again later.';
    } else if (lowerMessage.contains('security purposes') && lowerMessage.contains('only request this after')) {
      // Extract time remaining if possible
      final timeMatch = RegExp(r'after (\d+) seconds?').firstMatch(errorMessage);
      if (timeMatch != null) {
        final seconds = timeMatch.group(1);
        return 'Too many signup attempts. Please wait $seconds seconds before trying again.';
      }
      return 'Too many signup attempts. Please wait a moment before trying again.';
    }
    
    // Return the actual error message for debugging
    return errorMessage;
  }
}


