// lib/services/order_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/order_submission_model.dart';
import '../models/order_history_model.dart';

class OrderService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<int> submitOrder({required OrderSubmissionData orderData}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final newOrder = await _supabaseClient
          .from('orders')
          .insert({
            'user_id': userId,
            'total_amount': orderData.totalAmount,
            'status': orderData.status,
            'order_type': orderData.orderType,
            'delivery_address': orderData.deliveryAddress,
            'contact_number': orderData.contactNumber,
            'payment_method': orderData.paymentMethod,
          })
          .select('id')
          .single();

      final newOrderId = newOrder['id'] as int;

      final items = orderData.cartItems.map((item) {
        return {
          'order_id': newOrderId,
          'product_id': item.product.id,
          'quantity': item.quantity,
          'unit_price': item.product.price,
          'total_price': item.totalPrice,
        };
      }).toList();

      await _supabaseClient.from('order_items').insert(items);
      return newOrderId;
    } catch (e) {
      throw Exception('Order submission failed: $e');
    }
  }

  Future<List<OrderHistoryModel>> fetchUserOrders() async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await _supabaseClient
        .from('orders')
        .select('''
            id, total_amount, status, created_at,
            order_items (quantity, unit_price, product_id (name))
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => OrderHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderHistoryModel>> fetchAllOrders() async {
    final response = await _supabaseClient
        .from('orders')
        .select('''
            id, total_amount, status, created_at, user_id,
            profiles:user_id (full_name),
            order_items (id, quantity, unit_price, product_id (name))
        ''')
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => OrderHistoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await _supabaseClient.from('orders').update({'status': newStatus}).eq('id', orderId);
  }
}
