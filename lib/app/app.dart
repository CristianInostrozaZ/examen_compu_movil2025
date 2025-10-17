import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppVentas',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.login, 
    );
  }
}
