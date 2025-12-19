// lib/providers/cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- STATE DEFINITION ---
class CartState {
  final List<dynamic> items;
  final double totalPrice;

  CartState({required this.items, required this.totalPrice});

  CartState copyWith({
    List<dynamic>? items,
    double? totalPrice,
  }) {
    return CartState(
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

// --- NOTIFIER ---
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: [], totalPrice: 0.0));

  void clearCart() {
    state = CartState(items: [], totalPrice: 0.0);
  }

  void addItem(dynamic item, double price) {
    final newItems = [...state.items, item];
    final newTotal = state.totalPrice + price;
    state = CartState(items: newItems, totalPrice: newTotal);
  }

  void removeItem(dynamic item, double price) {
    final newItems = state.items.where((i) => i != item).toList();
    final newTotal = state.totalPrice - price;
    state = CartState(items: newItems, totalPrice: newTotal);
  }
}

// --- PROVIDER ---
final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
