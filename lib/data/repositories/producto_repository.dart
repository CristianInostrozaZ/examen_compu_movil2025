import 'dart:convert';
import '../api_client.dart';
import '../models/producto.dart';

class ProductoRepository {
  Future<List<Producto>> list() async {
    final r = await ApiClient.get('/ejemplos/product_list_rest/');
    if (r.statusCode != 200) {
      throw Exception('List products: ${r.statusCode} - ${r.body}');
    }

    final decoded = json.decode(r.body);
    if (decoded is List) {
      return productosFromJson(decoded.cast<Map<String, dynamic>>());
    } else if (decoded is Map<String, dynamic>) {
      final list = (decoded['products'] ??
          decoded['data'] ??
          decoded['items'] ??
          decoded['rows'] ??
          decoded['list'] ??
          decoded['lista'] ??
          decoded.values.firstWhere((v) => v is List, orElse: () => [])) as List;
      return productosFromJson(list.cast<Map<String, dynamic>>());
    } else {
      return [];
    }
  }

  Future<void> add({
    required String name,
    required num price,
    required String image,
  }) async {
    final r = await ApiClient.post('/ejemplos/product_add_rest/', {
      'product_name': name,
      'product_price': price,
      'product_image': image,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Add product: ${r.body}');
    }
  }

  Future<void> edit({
    required int id,
    required String name,
    required num price,
    required String image,
    required String state,
  }) async {
    final r = await ApiClient.post('/ejemplos/product_edit_rest/', {
      'product_id': id,
      'product_name': name,
      'product_price': price,
      'product_image': image,
      'product_state': state,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Edit product: ${r.body}');
    }
  }

  Future<void> delete(int id) async {
    final r = await ApiClient.post('/ejemplos/product_del_rest/', {
      'product_id': id,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Delete product: ${r.body}');
    }
  }
}
