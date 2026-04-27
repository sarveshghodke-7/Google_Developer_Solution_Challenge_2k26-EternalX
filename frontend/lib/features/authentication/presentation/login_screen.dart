import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/constants/app_constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppConstants.paddingS),
              Text('Enter your details to access your portal.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppConstants.paddingXL),
              
              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              const ShadcnInput(hintText: 'm.scott@example.com'),
              const SizedBox(height: AppConstants.paddingL),
              
              Text('Password', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              const ShadcnInput(hintText: '••••••••', isPassword: true),
              const SizedBox(height: AppConstants.paddingXL),
              
              ShadcnButton(
                text: 'Sign In',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: AppConstants.paddingL),
              
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
