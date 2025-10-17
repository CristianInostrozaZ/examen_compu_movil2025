import 'package:flutter/material.dart';
import '../../data/models/proveedor.dart';
import '../../data/repositories/proveedor_repository.dart';

class ProveedorFormScreen extends StatefulWidget {
  final Proveedor? proveedor;
  const ProveedorFormScreen({super.key, this.proveedor});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mailController = TextEditingController();
  final _repo = ProveedorRepository();

  static const List<String> _kStates = ['Activo', 'Inactivo'];
  String _state = 'Activo';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      _nameController.text = widget.proveedor!.providerName;
      _lastNameController.text = widget.proveedor!.providerLastName;
      _mailController.text = widget.proveedor!.providerMail;
      _state = widget.proveedor!.providerState;
      if (!_kStates.contains(_state)) _state = 'Activo';
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Requerido' : null;

  Future<void> _saveProveedor() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final p = Proveedor(
        providerId: widget.proveedor?.providerId ?? 0,
        providerName: _nameController.text.trim(),
        providerLastName: _lastNameController.text.trim(),
        providerMail: _mailController.text.trim(),
        providerState: _state,
      );

      if (widget.proveedor == null) {
        await _repo.add(p);
      } else {
        await _repo.edit(p);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _mailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.proveedor != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar Proveedor' : 'Nuevo Proveedor')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: _required,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: _required,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: _required,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _kStates.contains(_state) ? _state : _kStates.first,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: _kStates
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _state = v ?? 'Activo'),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProveedor,
                    child: Text(isEdit ? 'Guardar cambios' : 'Crear'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
