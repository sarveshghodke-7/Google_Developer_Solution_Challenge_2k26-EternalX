import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Health Intelligence App',
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, 
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false, 
    );
  }
}
