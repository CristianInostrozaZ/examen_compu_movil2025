import 'dart:convert';
import '../api_client.dart';
import '../models/proveedor.dart';

class ProveedorRepository {
 
  Future<List<Proveedor>> list({bool includeInactive = false}) async {
    final r = await ApiClient.get('/ejemplos/provider_list_rest/');
    if (r.statusCode != 200) {
      throw Exception('List providers: ${r.statusCode} - ${r.body}');
    }

    final decoded = json.decode(r.body);
    List<Proveedor> all;

    if (decoded is List) {
      all = proveedoresFromJson(decoded.cast<Map<String, dynamic>>());
    } else if (decoded is Map<String, dynamic>) {
      final list = (decoded['providers'] ??
          decoded['data'] ??
          decoded['items'] ??
          decoded['rows'] ??
          decoded['list'] ??
          decoded['lista'] ??
          decoded.values.firstWhere((v) => v is List, orElse: () => [])) as List;
      all = proveedoresFromJson(list.cast<Map<String, dynamic>>());
    } else {
      all = <Proveedor>[];
    }

    if (includeInactive) return all;
    return all
        .where((e) => !e.providerState.toLowerCase().startsWith('inactiv'))
        .toList();
  }

  
  Future<void> add(Proveedor p) async {
    final r = await ApiClient.post('/ejemplos/provider_add_rest/', {
      'provider_name': p.providerName.trim(),
      'provider_last_name': p.providerLastName.trim(),
      'provider_mail': p.providerMail.trim(),
      'provider_state': p.providerState.trim(),
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Add provider: ${r.statusCode} - ${r.body}');
    }
  }

  Future<void> edit(Proveedor p) async {
    if (p.providerId <= 0) {
      throw Exception('Edit: ID inválido');
    }
    final r = await ApiClient.post('/ejemplos/provider_edit_rest/', {
      'provider_id': p.providerId,
      'provider_name': p.providerName.trim(),
      'provider_last_name': p.providerLastName.trim(),
      'provider_mail': p.providerMail.trim(),
      'provider_state': p.providerState.trim(),
    });
    if (r.statusCode < 200 || r.statusCode >= 300) {
      throw Exception('Edit provider: ${r.statusCode} - ${r.body}');
    }
  }

  Future<void> delete(int id) async {
    if (id <= 0) throw Exception('ID inválido para eliminar: $id');

    
    final delBodies = [
      {'provider_id': id},
      {'provider_id': '$id'},
      {'id': id},
      {'id': '$id'},
    ];
    final delPaths = [
      '/ejemplos/provider_del_rest/',
      '/ejemplos/provider_del_rest',
    ];

    for (final path in delPaths) {
      for (final body in delBodies) {
        try {
          final r = await ApiClient.post(path, body);
          if (r.statusCode >= 200 && r.statusCode < 300) {
            
            final after = await list(includeInactive: true);
            final still = after.any((e) => e.providerId == id);
            if (!still) return; 
            
            break;
          }
        } catch (_) {
          
        }
      }
    }

    
    final all = await list(includeInactive: true);
    final idx = all.indexWhere((e) => e.providerId == id);
    if (idx == -1) {
      
      return;
    }
    final p = all[idx];
    final soft = Proveedor(
      providerId: p.providerId,
      providerName: p.providerName,
      providerLastName: p.providerLastName,
      providerMail: p.providerMail,
      providerState: 'Inactivo',
    );
    await edit(soft);

    
    final after = await list(includeInactive: true);
    final j = after.indexWhere((e) => e.providerId == id);
    if (j != -1 && !after[j].providerState.toLowerCase().startsWith('inactiv')) {
      throw Exception('No se pudo eliminar (ni inactivar) el proveedor $id');
    }
  }
}
