import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Admin email
  static const String adminEmail = 'aliabouali2005@gmail.com';

  /// Check if current user is admin
  Future<bool> isAdmin() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      // Check if user email matches admin email
      final userEmail = user.email?.toLowerCase().trim();
      if (userEmail == adminEmail.toLowerCase().trim()) {
        return true;
      }

      // Also check in user metadata (if stored there)
      final userMeta = user.userMetadata ?? {};
      if (userMeta['isAdmin'] == true || userMeta['role'] == 'admin') {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error checking admin status: $e');
      return false;
    }
  }

  /// Check if email is admin email
  static bool isAdminEmail(String email) {
    return email.toLowerCase().trim() == adminEmail.toLowerCase().trim();
  }

  /// Set admin status for a user
  Future<void> setAdminStatus(String userId, bool isAdmin) async {
    try {
      await _supabase
          .from('users')
          .update({
            'isAdmin': isAdmin,
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to set admin status: $e');
    }
  }

  /// Get current user ID
  String? get currentUserId => _supabase.auth.currentUser?.id;
}
