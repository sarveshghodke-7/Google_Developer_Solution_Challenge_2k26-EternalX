import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: ListView(
        padding: AppConstants.screenPadding,
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Manage your health profile data',
            onTap: () => context.push('/profile'),
          ),
          _buildSettingTile(
            icon: Icons.lock_outline,
            title: 'Security',
            subtitle: 'Password and biometric settings',
            onTap: () {},
          ),
          
          const SizedBox(height: AppConstants.paddingL),
          _buildSectionHeader('Preferences'),
          _buildSettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Configure health alerts and reminders',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: 'Appearance',
            subtitle: 'Switch between light and dark mode',
            onTap: () {},
          ),

          const SizedBox(height: AppConstants.paddingL),
          _buildSectionHeader('Support & Legal'),
          _buildSettingTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {},
          ),

          const SizedBox(height: AppConstants.paddingXL),
          
          // Logout Button
          TextButton(
            onPressed: () {
              // Clear session and go to login
              context.go('/login');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingM),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 20),
                SizedBox(width: 8),
                Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: AppConstants.paddingL),
          Center(
            child: Text(
              'Version ${AppConstants.appVersion}',
              style: const TextStyle(color: AppTheme.textMuted, fontSize: AppTypography.labelTiny),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.textMuted,
          fontSize: AppTypography.labelTiny,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: AppTypography.bodyMedium)) : null,
        trailing: const Icon(Icons.chevron_right, size: 20, color: AppTheme.textMuted),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
      ),
    );
  }
}
