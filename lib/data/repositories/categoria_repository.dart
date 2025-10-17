import 'dart:convert';
import '../api_client.dart';
import '../models/categoria.dart';

class CategoriaRepository {
  Future<List<Categoria>> list() async {
    final r = await ApiClient.get('/ejemplos/category_list_rest/');
    if (r.statusCode != 200) {
      throw Exception('List categories: ${r.statusCode} - ${r.body}');
    }
    final decoded = json.decode(r.body);

    if (decoded is List) {
      return categoriasFromJson(decoded.cast<Map<String, dynamic>>());
    }
    if (decoded is Map<String, dynamic>) {
      final list = (decoded['categories'] ??
          decoded['data'] ??
          decoded['items'] ??
          decoded['rows'] ??
          decoded['list'] ??
          decoded['lista'] ??
          decoded.values.firstWhere((v) => v is List, orElse: () => [])) as List;
      return categoriasFromJson(list.cast<Map<String, dynamic>>());
    }
    return [];
  }

  Future<void> add({required String name, String state = 'Activa'}) async {
    final r = await ApiClient.post('/ejemplos/category_add_rest/', {
      'category_name': name,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Add category: ${r.body}');
    }
  }

  Future<void> edit({
    required int id,
    required String name,
    required String state,
  }) async {
    final r = await ApiClient.post('/ejemplos/category_edit_rest/', {
      'category_id': id,
      'category_name': name,
      'category_state': state,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Edit category: ${r.body}');
    }
  }

  Future<void> delete(int id) async {
    final r = await ApiClient.post('/ejemplos/category_del_rest/', {
      'category_id': id,
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Delete category: ${r.body}');
    }
  }
}
