// lib/providers/product_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

// --- SERVICE PROVIDER ---
final productService = Provider((ref) => ProductService());

// --- PRODUCT LIST PROVIDER ---
final productListProvider = FutureProvider<List<ProductModel>>((ref) async {
  final service = ref.read(productService);
  return service.fetchProducts();
});
