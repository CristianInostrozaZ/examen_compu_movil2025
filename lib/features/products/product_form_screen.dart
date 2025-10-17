import 'package:flutter/material.dart';
import '../../data/models/producto.dart';
import '../../data/repositories/producto_repository.dart';

class ProductFormScreen extends StatefulWidget {
  final Producto? producto;
  const ProductFormScreen({super.key, this.producto});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  String _state = 'Activo';
  bool _isLoading = false;

  final _repo = ProductoRepository();

  @override
  void initState() {
    super.initState();
    final p = widget.producto;
    if (p != null) {
      _nameCtrl.text = p.productName;
      _priceCtrl.text = p.productPrice.toString();
      _imageCtrl.text = p.productImage;
      _state = p.productState ?? 'Activo';
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Requerido' : null;
  String? _priceValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Requerido';
    final num? n = num.tryParse(v);
    if (n == null || n <= 0) return 'Precio inválido';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final name = _nameCtrl.text.trim();
      final price = num.parse(_priceCtrl.text.trim());
      final image = _imageCtrl.text.trim();

      if (widget.producto == null) {
        await _repo.add(name: name, price: price, image: image);
      } else {
        await _repo.edit(
          id: widget.producto!.productId,
          name: name,
          price: price,
          image: image,
          state: _state,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.producto != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Producto' : 'Nuevo Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: _required,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: _priceValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: 'URL Imagen'),
                validator: _required,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              if (_imageCtrl.text.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _imageCtrl.text,
                    height: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Center(child: Text('No se pudo cargar la imagen')),
                  ),
                ),
              if (isEdit) ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _state,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: const ['Activo', 'Inactivo']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => _state = v!),
                ),
              ],
              const SizedBox(height: 24),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _save,
                  child: Text(isEdit ? 'Actualizar' : 'Crear'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
