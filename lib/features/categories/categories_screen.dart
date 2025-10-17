import 'package:flutter/material.dart';
import '../../data/models/categoria.dart';
import '../../data/repositories/categoria_repository.dart';
import 'categoria_form_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _repo = CategoriaRepository();
  Future<List<Categoria>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.list();
  }

 Future<void> _reload() async {
  final newFuture = _repo.list(); 
  setState(() {
    _future = newFuture;
  });
}
  Future<void> _refresh() async => _reload();

  Future<void> _delete(Categoria c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Eliminar la categoría "${c.categoryName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await _repo.delete(c.categoryId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Categoría eliminada'), backgroundColor: Colors.green),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _openForm({Categoria? categoria}) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CategoriaFormScreen(categoria: categoria)),
    );
    if (changed == true && mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    _future ??= _repo.list();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: FutureBuilder<List<Categoria>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting || _future == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ocurrió un error al cargar:\n${snap.error}', textAlign: TextAlign.center),
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

          final data = snap.data ?? [];
          if (data.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 160),
                  Center(child: Text('No hay categorías.')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = data[i];
                return ListTile(
                  leading: CircleAvatar(child: Text('${c.categoryId}')),
                  title: Text(c.categoryName.isEmpty ? '(sin nombre)' : c.categoryName),
                  subtitle: Text(c.categoryState),
                  onTap: () => _openForm(categoria: c),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Editar',
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openForm(categoria: c),
                      ),
                      IconButton(
                        tooltip: 'Eliminar',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _delete(c),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Nueva categoría',
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
