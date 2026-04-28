import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Support'),
      ),
      body: ListView(
        padding: AppConstants.screenPadding,
        children: [
          Text('How can we help?', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppConstants.paddingS),
          Text('Get assistance with your app or health data.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingXL),

          _buildSupportTile(context, Icons.chat_bubble_outline, 'Chat with MediBot', '24/7 AI Health Assistant'),
          _buildSupportTile(context, Icons.phone_outlined, 'Call the Clinic', 'Mon-Fri, 9am - 5pm'),
          _buildSupportTile(context, Icons.email_outlined, 'Email Support', 'Expected response: 24 hours'),
          _buildSupportTile(context, Icons.menu_book_outlined, 'FAQ', 'Read common questions'),
        ],
      ),
    );
  }

  Widget _buildSupportTile(BuildContext context, IconData icon, String title, String subtitle) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL, vertical: AppConstants.paddingXS),
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.3)),
        onTap: () {},
      ),
    );
  }
}
