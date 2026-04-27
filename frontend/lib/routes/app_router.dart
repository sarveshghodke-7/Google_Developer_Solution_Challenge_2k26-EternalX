import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/splash_screen.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/report_analyzer/presentation/upload_screen.dart';
import '../features/report_analyzer/presentation/insights_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', 
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
        path: '/upload',
        builder: (BuildContext context, GoRouterState state) {
        return const UploadScreen();
      },
    ),
    GoRoute(
      path: '/insights',
      builder: (BuildContext context, GoRouterState state) {
        return const InsightsScreen();
      }
    )
  ],
);
