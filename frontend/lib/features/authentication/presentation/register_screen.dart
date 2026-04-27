import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/constants/app_constants.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create account', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppConstants.paddingS),
              
              Text('Register to manage your healthcare.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppConstants.paddingXL),
              
              Text('Full Name', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              const ShadcnInput(hintText: 'Raju Rastogi'),
              const SizedBox(height: AppConstants.paddingL),

              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              const ShadcnInput(hintText: 'rajurastojixxx@gmail.com'),
              const SizedBox(height: AppConstants.paddingL),
              
              Text('Password', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              const ShadcnInput(hintText: '••••••••', isPassword: true),
              const SizedBox(height: AppConstants.paddingXL),
              
              ShadcnButton(
                text: 'Register',
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
