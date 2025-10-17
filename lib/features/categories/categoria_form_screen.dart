import 'package:flutter/material.dart';
import '../../data/models/categoria.dart';
import '../../data/repositories/categoria_repository.dart';

class CategoriaFormScreen extends StatefulWidget {
  final Categoria? categoria;
  const CategoriaFormScreen({super.key, this.categoria});

  @override
  State<CategoriaFormScreen> createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  static const List<String> _kStates = ['Activa', 'Inactiva'];
  String _state = _kStates.first;
  bool _isLoading = false;

  final _repo = CategoriaRepository();

  String _normalizeState(String? raw) {
    if (raw == null) return 'Activa';
    final s = raw.trim().toLowerCase();
    if (s == 'a' || s.startsWith('activ')) return 'Activa';
    if (s == 'i' || s.startsWith('inactiv')) return 'Inactiva';
    if (raw == 'Activa' || raw == 'Inactiva') return raw;
    return 'Activa';
  }

  @override
  void initState() {
    super.initState();
    if (widget.categoria != null) {
      _nameController.text = widget.categoria!.categoryName;
      _state = _normalizeState(widget.categoria!.categoryState);
    }
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Nombre requerido' : null;

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      if (widget.categoria == null) {
        await _repo.add(name: _nameController.text.trim(), state: _state);
      } else {
        await _repo.edit(
          id: widget.categoria!.categoryId,
          name: _nameController.text.trim(),
          state: _state,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.categoria != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Categoría' : 'Nueva Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre de Categoría'),
                validator: _required,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _kStates.contains(_state) ? _state : _kStates.first,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _kStates.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _state = v!),
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _saveCategory,
                  child: Text(isEdit ? 'Actualizar' : 'Crear'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
