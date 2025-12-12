import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user.dart';

class CheckoutService {
  static final CheckoutService _instance = CheckoutService._internal();
  factory CheckoutService() => _instance;
  CheckoutService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> processCheckout({
    required List<CartItem> items,
    required Address shippingAddress,
    required PaymentMethod paymentMethod,
    String? notes,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in, cannot process checkout');
        return null;
      }

      // Calculate total
      double totalAmount = 0;
      for (var item in items) {
        totalAmount += item.price * item.quantity;
      }

      // Generate order number
      final orderNumber =
          'NEX-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch}';

      // Insert order into database
      final orderResponse = await _supabase
          .from('orders')
          .insert({
            'user_id': user.id,
            'order_number': orderNumber,
            'total_amount': totalAmount,
            'status': 'pending',
            'shipping_address_id': shippingAddress.id,
            'payment_method': paymentMethod.name,
            'payment_status': 'pending',
            'order_date': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      final orderId = orderResponse['id'];

      // Insert order items
      for (var item in items) {
        await _supabase.from('order_items').insert({
          'order_id': orderId,
          'product_id': item.productId,
          'product_name': item.productName,
          'product_image': item.productImage,
          'price': item.price,
          'quantity': item.quantity,
        });
      }

      debugPrint('Order created successfully: $orderNumber');
      return orderNumber;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return null;
    }
  }

  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in');
        return false;
      }

      await _supabase
          .from('orders')
          .update({
            'status': newStatus.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('user_id', user.id);

      debugPrint('Order status updated to ${newStatus.name}');
      return true;
    } catch (e) {
      debugPrint('Update order status error: $e');
      return false;
    }
  }

  Future<bool> addTrackingNumber(String orderId, String trackingNumber) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in');
        return false;
      }

      await _supabase
          .from('orders')
          .update({
            'tracking_number': trackingNumber,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('user_id', user.id);

      debugPrint('Tracking number added: $trackingNumber');
      return true;
    } catch (e) {
      debugPrint('Add tracking number error: $e');
      return false;
    }
  }

  Future<bool> updateDeliveryDate(String orderId, DateTime deliveryDate) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in');
        return false;
      }

      await _supabase
          .from('orders')
          .update({
            'delivery_date': deliveryDate.toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('user_id', user.id);

      debugPrint('Delivery date updated');
      return true;
    } catch (e) {
      debugPrint('Update delivery date error: $e');
      return false;
    }
  }

  Future<bool> updatePaymentStatus(String orderId, String paymentStatus) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        debugPrint('No user logged in');
        return false;
      }

      await _supabase
          .from('orders')
          .update({
            'payment_status': paymentStatus,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .eq('user_id', user.id);

      debugPrint('Payment status updated to $paymentStatus');
      return true;
    } catch (e) {
      debugPrint('Update payment status error: $e');
      return false;
    }
  }
}

enum PaymentMethod {
  creditCard,
  debitCard,
  paypal,
  applePay,
  googlePay,
  bankTransfer,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
    }
  }

  String get icon {
    switch (this) {
      case PaymentMethod.creditCard:
        return '💳';
      case PaymentMethod.debitCard:
        return '💳';
      case PaymentMethod.paypal:
        return '🅿️';
      case PaymentMethod.applePay:
        return '🍎';
      case PaymentMethod.googlePay:
        return '🅶';
      case PaymentMethod.bankTransfer:
        return '🏦';
    }
  }
}
