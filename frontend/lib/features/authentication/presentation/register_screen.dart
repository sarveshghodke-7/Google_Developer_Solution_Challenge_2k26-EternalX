import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';

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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create account', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('Register to manage your healthcare.'),
              const SizedBox(height: 32),
              
              const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 8),
              const ShadcnInput(hintText: 'John Doe'),
              const SizedBox(height: 16),

              const Text('Email', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 8),
              const ShadcnInput(hintText: 'name@example.com'),
              const SizedBox(height: 16),
              
              const Text('Password', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
              const SizedBox(height: 8),
              const ShadcnInput(hintText: '••••••••', isPassword: true),
              const SizedBox(height: 32),
              
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
