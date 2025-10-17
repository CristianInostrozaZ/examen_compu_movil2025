import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
  static const Color kBgCeleste   = Color(0xFFEAF5FF);
  static const Color kAzulTitulo  = Color(0xFF0A66C2);
  static const Color kCelesteBtn  = Color(0xFF7CC6FF);
  static const Color kTextoOscuro = Color(0xFF1F2937);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar sesión: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: kBgCeleste,
      
      appBar: AppBar(
        backgroundColor: kBgCeleste,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  const Center(
                    child: Text(
                      'Home',
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
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (user != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(
                                'Bienvenido, ${user.email}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: kTextoOscuro,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                          const SizedBox(height: 6),
                          const Text(
                            'Selecciona un módulo:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kTextoOscuro,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 22),

                          // Módulo Proveedores
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.business),
                              label: const Text('Módulo Proveedores'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCelesteBtn,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/providers'),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Módulo Categorías
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.category),
                              label: const Text('Módulo Categorías'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCelesteBtn,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/categories'),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Módulo Productos
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Módulo Productos'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kCelesteBtn,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/products'),
                            ),
                          ),
                        ],
                      ),
                    ),
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
