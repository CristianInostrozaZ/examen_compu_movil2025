import 'package:flutter/material.dart';
import '../../data/models/proveedor.dart';
import '../../data/repositories/proveedor_repository.dart';
import 'proveedor_form_screen.dart';

class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  final _repo = ProveedorRepository();
  late Future<List<Proveedor>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.list();
  }

  Future<void> _reload() async {
    setState(() {
      _future = _repo.list();
    });
  }
  Future<void> _openForm({Proveedor? proveedor}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => ProveedorFormScreen(proveedor: proveedor)),
    );
    if (changed == true && mounted) _reload();
  }

  Future<void> _delete(Proveedor p) async {
    try {
      await _repo.delete(p.providerId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Eliminado: ${p.providerName} ${p.providerLastName}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Nuevo proveedor',
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const ProveedorFormScreen()),
          );
          if (saved == true) _reload();
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<Proveedor>>(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No se pudieron cargar los proveedores'),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _reload,
              child: ListView(
                children: const [
                  SizedBox(height: 160),
                  Center(child: Text('No hay proveedores.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reload,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 4),
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.business),
                  ),
                  title: Text('${p.providerName} ${p.providerLastName}'),
                  subtitle: Text('${p.providerMail} · ${p.providerState}'),
                  onTap: () => _openForm(proveedor: p),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(proveedor: p),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(p),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
