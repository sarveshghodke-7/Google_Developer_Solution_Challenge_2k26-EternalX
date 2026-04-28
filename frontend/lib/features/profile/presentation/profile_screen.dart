import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _reportsFuture;

  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    _reportsFuture = _apiService.fetchReports(userId);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppConstants.paddingL),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    user?.displayName?.isNotEmpty == true
                        ? user!.displayName![0].toUpperCase()
                        : '?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.paddingXL),
              
              Text('Name', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(user?.displayName ?? 'No name set', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingL),
              
              Text('Email', style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(user?.email ?? 'No email', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingXL),
              
              Text('Report History', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppConstants.paddingS),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _reportsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading reports', style: TextStyle(color: theme.colorScheme.error));
                    }
                    final reports = snapshot.data ?? [];
                    if (reports.isEmpty) {
                      return Text('0 files uploaded', style: theme.textTheme.bodyMedium);
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${reports.length} file(s) uploaded', style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Expanded(
                          child: ListView.builder(
                            itemCount: reports.length,
                            itemBuilder: (context, index) {
                              final report = reports[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.description),
                                title: Text('Report ${report['id'].toString().substring(0, 6)}...'),
                                subtitle: Text('Analysis ID: ${report['hash'].toString().substring(0, 8)}...'),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              
              ShadcnButton(
                text: 'Log Out',
                isOutlined: true,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) context.go('/');
                },
              ),
              const SizedBox(height: AppConstants.paddingL),
            ],
          ),
        ),
      ),
    );
  }
}
