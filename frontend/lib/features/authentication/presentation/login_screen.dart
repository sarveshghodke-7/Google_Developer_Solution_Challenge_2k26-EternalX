import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              ShadcnInput(hintText: 'm.scott@example.com', controller: _emailController),
              const SizedBox(height: AppConstants.paddingL),
              
              Text('Password', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              ShadcnInput(hintText: '••••••••', isPassword: true, controller: _passwordController),
              const SizedBox(height: AppConstants.paddingXL),
              
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ShadcnButton(
                    text: 'Sign In',
                    onPressed: _login,
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
