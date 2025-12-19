// lib/providers/menu_cart_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

// --- MODEL: CartItemModel ---
class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({required this.product, required this.quantity});

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;
}

// --- NOTIFIER ---
class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = state.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      final existingItem = state[existingIndex];
      final newQuantity = existingItem.quantity + quantity;
      state = [
        ...state.sublist(0, existingIndex),
        existingItem.copyWith(quantity: newQuantity),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, CartItemModel(product: product, quantity: quantity)];
    }
  }

  void removeItem(CartItemModel item) {
    state = state.where((i) => i.product.id != item.product.id).toList();
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(item);
      return;
    }
    state = [
      for (final cartItem in state)
        if (cartItem.product.id == item.product.id)
          cartItem.copyWith(quantity: newQuantity)
        else
          cartItem,
    ];
  }

  void clearCart() {
    state = [];
  }
}

// --- PROVIDER ---
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});
