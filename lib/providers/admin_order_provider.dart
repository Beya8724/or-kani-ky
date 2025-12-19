// lib/providers/admin_order_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_history_model.dart';
import '../services/order_service.dart';

// --- SERVICE PROVIDER ---
final orderServiceProvider = Provider((ref) => OrderService());

// --- ADMIN ORDER NOTIFIER ---
class AdminOrderListNotifier extends StateNotifier<AsyncValue<List<OrderHistoryModel>>> {
  final OrderService _orderService;

  AdminOrderListNotifier(this._orderService) : super(const AsyncValue.loading()) {
    fetchAllOrders();
  }

  Future<void> fetchAllOrders() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    try {
      final orders = await _orderService.fetchAllOrders();
      state = AsyncValue.data(orders);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    final oldOrders = state.value;
    if (oldOrders == null) return;

    final updatedOrders = oldOrders.map((order) {
      if (order.id == orderId) return order.copyWith(status: newStatus);
      return order;
    }).toList();

    state = AsyncValue.data(updatedOrders);

    try {
      await _orderService.updateOrderStatus(orderId, newStatus);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      state = AsyncValue.data(oldOrders);
    }
  }
}

// --- PROVIDER ---
final adminOrderListProvider =
    StateNotifierProvider<AdminOrderListNotifier, AsyncValue<List<OrderHistoryModel>>>(
        (ref) {
  final service = ref.watch(orderServiceProvider);
  return AdminOrderListNotifier(service);
});
