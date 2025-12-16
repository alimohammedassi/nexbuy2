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

  /// Fetch all orders for admin dashboard
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final response = await _supabase
          .from('orders')
          .select(
            '*, order_items(*), addresses(*)',
          ) // Assuming relationship names
          .order('order_date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching all orders: $e');
      return [];
    }
  }

  /// Update order status (Admin)
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      // Update status
      await _supabase
          .from('orders')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);

      // Try to send notification, but don't fail the whole operation if it fails
      try {
        // Fetch user_id to send notification
        final orderData = await _supabase
            .from('orders')
            .select('user_id, order_number')
            .eq('id', orderId)
            .single();

        final userId = orderData['user_id'];
        final orderNumber = orderData['order_number'];

        // Send notification
        if (userId != null) {
          await _supabase.from('notifications').insert({
            'user_id': userId,
            'title': 'Order Status Updated',
            'message': 'Order #$orderNumber is now $newStatus.',
            'type': 'orderUpdate',
            'is_read': false,
            'created_at': DateTime.now().toIso8601String(),
            'data': {'orderId': orderId, 'status': newStatus},
          });
        }
      } catch (notifyError) {
        debugPrint('Warning: Failed to send notification: $notifyError');
      }

      return true;
    } catch (e) {
      debugPrint('Error updating order status (admin): $e');
      return false;
    }
  }
}
