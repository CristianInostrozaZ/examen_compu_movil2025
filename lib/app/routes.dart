import 'package:flutter/material.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/proveedores/proveedores_screen.dart';
import '../features/categories/categories_screen.dart';
import '../features/products/products_screen.dart';



class AppRoutes {
  static const login = '/login';
  static const register = '/register';

  static const home = '/home';
  static const providers = '/providers';
  static const categories = '/categories';
  static const products = '/products';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const HomeScreen(),
    providers: (_) => const ProveedoresScreen(),
    categories: (_) => const CategoriesScreen(),
    products: (_) => const ProductsScreen(),
    
  };
}
