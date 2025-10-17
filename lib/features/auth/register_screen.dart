import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _isLoading = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  final _auth = FirebaseAuth.instance;

  static const Color kBgCeleste   = Color(0xFFEAF5FF);
  static const Color kAzulTitulo  = Color(0xFF0A66C2);
  static const Color kCelesteBtn  = Color(0xFF7CC6FF);
  static const Color kTextoOscuro = Color(0xFF1F2937);

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email requerido';
    final s = v.trim();
    if (!s.contains('@') || !s.contains('.')) return 'Email inválido';
    return null;
  }

  String? _passValidator(String? v) {
    if (v == null || v.isEmpty) return 'Contraseña requerida';
    if (v.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _pass2Validator(String? v) {
    if (v == null || v.isEmpty) return 'Confirma la contraseña';
    if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

  
      await cred.user?.sendEmailVerification();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta creada. Revisa tu correo para verificarla.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); 
    } on FirebaseAuthException catch (e) {
      String msg = 'Error al registrar';
      switch (e.code) {
        case 'email-already-in-use':
          msg = 'El correo ya está registrado.'; break;
        case 'invalid-email':
          msg = 'Correo inválido.'; break;
        case 'weak-password':
          msg = 'La contraseña es demasiado débil.'; break;
        case 'operation-not-allowed':
          msg = 'Habilita Email/Password en Firebase Auth.'; break;
        default:
          msg = e.message ?? msg;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error inesperado: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgCeleste,
      appBar: AppBar(
        backgroundColor: kBgCeleste,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  const Center(
                    child: Text(
                      'Crear cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kAzulTitulo,
                        fontSize: 32,          
                        fontWeight: FontWeight.w800,
                        letterSpacing: .4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _emailValidator,
                              style: const TextStyle(color: kTextoOscuro),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passCtrl,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                border: const OutlineInputBorder(),
                                isDense: true,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                                ),
                              ),
                              obscureText: _obscure1,
                              validator: _passValidator,
                              style: const TextStyle(color: kTextoOscuro),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _pass2Ctrl,
                              decoration: InputDecoration(
                                labelText: 'Confirmar contraseña',
                                border: const OutlineInputBorder(),
                                isDense: true,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                                ),
                              ),
                              obscureText: _obscure2,
                              validator: _pass2Validator,
                              style: const TextStyle(color: kTextoOscuro),
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(height: 18),

                            if (_isLoading)
                              const Center(child: CircularProgressIndicator())
                            else
                              SizedBox(
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kCelesteBtn,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Crear cuenta',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
