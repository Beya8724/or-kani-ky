// lib/providers/order_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order_history_model.dart';
import '../models/order_submission_model.dart';
import '../services/order_service.dart';

// --- SERVICE PROVIDER ---
final orderService = Provider((ref) => OrderService());

// --- ASYNC NOTIFIER PROVIDER ---
final orderListProvider =
    AsyncNotifierProvider<OrderListNotifier, List<OrderHistoryModel>>(() {
  return OrderListNotifier();
});

class OrderListNotifier extends AsyncNotifier<List<OrderHistoryModel>> {
  @override
  Future<List<OrderHistoryModel>> build() async {
    final service = ref.read(orderService);
    return service.fetchUserOrders();
  }

  Future<void> refreshOrders() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(orderService).fetchUserOrders());
  }

  Future<void> submitOrder(OrderSubmissionData orderData) async {
    await ref.read(orderService).submitOrder(orderData: orderData);
  }
}
