// lib/services/product_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final String _table = 'products';

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await _supabaseClient.from(_table).select('*').order('id');
      return (response as List)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
