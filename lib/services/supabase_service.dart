import 'package:supabase_flutter/supabase_flutter.dart';

/// Service class for accessing Supabase client instance
///
/// Usage:
/// ```dart
/// final supabase = SupabaseService.instance;
/// await supabase.from('table_name').select();
/// ```
class SupabaseService {
  /// Get the Supabase client instance
  static SupabaseClient get instance => Supabase.instance.client;

  /// Get the current authenticated user
  static User? get currentUser => instance.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get the current session
  static Session? get currentSession => instance.auth.currentSession;
}
