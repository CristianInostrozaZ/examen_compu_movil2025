import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;  
  bool _isLoading = false;             
  bool _obscure = true;

  
  static const Color kBgCeleste   = Color(0xFFEAF5FF); 
  static const Color kAzulTitulo  = Color(0xFF0A66C2); 
  static const Color kCelesteBtn  = Color(0xFF7CC6FF); 
  static const Color kTextoOscuro = Color(0xFF1F2937);

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
                  
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'AppVentas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kAzulTitulo,
                        fontSize: 36,       
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(color: kTextoOscuro),
                          ),
                          const SizedBox(height: 14),

                          
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: const OutlineInputBorder(),
                              isDense: true,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            obscureText: _obscure,
                            style: const TextStyle(color: kTextoOscuro),
                          ),
                          const SizedBox(height: 18),

                          if (_isLoading)
                            const Center(child: CircularProgressIndicator())
                          else ...[
                            
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kCelesteBtn,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            
                            SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, '/register'),
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
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ¿Olvidaste tu contraseña? extra examen
                  TextButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Future<void> _login() async {
    setState(() { _isLoading = true; });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Error desconocido';
      switch (e.code) {
        case 'user-not-found':
          errorMsg = 'Usuario no encontrado. Regístrate primero.'; break;
        case 'wrong-password':
          errorMsg = 'Contraseña incorrecta.'; break;
        case 'invalid-email':
          errorMsg = 'Formato de email inválido.'; break;
        case 'user-disabled':
          errorMsg = 'Cuenta deshabilitada.'; break;
        case 'too-many-requests':
          errorMsg = 'Demasiados intentos. Intenta más tarde.'; break;
        default:
          errorMsg = e.message ?? 'Error en autenticación';
      }
      _showError(errorMsg);
    } catch (e) {
      _showError('Error inesperado: $e');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Ingresa tu email para recuperar la contraseña');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Te enviamos un correo para restablecer la contraseña'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showError('No se pudo enviar el correo: $e');
    }
  }

  
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
