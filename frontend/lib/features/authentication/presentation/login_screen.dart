import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('Enter your details to access your portal.'),
              const SizedBox(height: 32),
              
              const Text('Email', style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppTypography.bodyMedium)),
              const SizedBox(height: 8),
              const ShadcnInput(hintText: 'm.scott@example.com'),
              const SizedBox(height: 16),
              
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w500, fontSize: AppTypography.bodyMedium)),
              const SizedBox(height: 8),
              const ShadcnInput(hintText: '••••••••', isPassword: true),
              const SizedBox(height: 32),
              
              ShadcnButton(
                text: 'Sign In',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 16),
              
              ShadcnButton(
                text: 'Create an account',
                isOutlined: true,
                onPressed: () => context.push('/register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
