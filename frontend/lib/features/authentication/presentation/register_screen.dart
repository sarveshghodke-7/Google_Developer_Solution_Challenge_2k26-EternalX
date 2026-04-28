import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/widgets/input.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/constants/app_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      await userCredential.user?.updateDisplayName(_nameController.text.trim());
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              ShadcnInput(hintText: 'Raju Rastogi', controller: _nameController),
              const SizedBox(height: AppConstants.paddingL),

              Text('Email', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              ShadcnInput(hintText: 'rajurastojixxx@gmail.com', controller: _emailController),
              const SizedBox(height: AppConstants.paddingL),
              
              Text('Password', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              ShadcnInput(hintText: '••••••••', isPassword: true, controller: _passwordController),
              const SizedBox(height: AppConstants.paddingXL),
              
              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ShadcnButton(
                    text: 'Register',
                    onPressed: _register,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
