import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _safeAction(VoidCallback action) {
    Future.microtask(action);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), 
        centerTitle: false,
        leading: context.canPop() 
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => _safeAction(() => context.pop()),
            ) 
          : null,
      ),
      body: ListView(
        padding: AppConstants.screenPadding,
        children: [
          _buildSectionHeader(context, 'Account'),
          _buildSettingTile(
            context: context,
            icon: Icons.person_outline,
            title: 'Personal Information',
            subtitle: 'Manage your health profile data',
            onTap: () => _safeAction(() => context.push('/profile')),
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.lock_outline,
            title: 'Security',
            subtitle: 'Password and biometric settings',
            onTap: () => _safeAction(() => print("Security tapped")),
          ),
          
          const SizedBox(height: AppConstants.paddingL),
          _buildSectionHeader(context, 'Preferences'),
          _buildSettingTile(
            context: context,
            icon: Icons.notifications_none,
            title: 'Notifications',
            subtitle: 'Configure health alerts and reminders',
            onTap: () => _safeAction(() => print("Notifications tapped")),
          ),
          
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.themeNotifier,
            builder: (context, themeMode, _) {
              final isDark = themeMode == ThemeMode.dark;
              
              return Container(
                margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                ),
                child: SwitchListTile(
                  activeColor: theme.colorScheme.primary,
                  secondary: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode, 
                    color: theme.colorScheme.primary,
                  ),
                  title: Text('Dark Mode', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('Switch between light and dark themes', style: theme.textTheme.bodyMedium),
                  value: isDark,
                  onChanged: (bool value) {
                    _safeAction(() {
                      AppTheme.themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                    });
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
                ),
              );
            }
          ),

          const SizedBox(height: AppConstants.paddingL),
          _buildSectionHeader(context, 'Support & Legal'),
          _buildSettingTile(
            context: context,
            icon: Icons.help_outline,
            title: 'Help Center',
            onTap: () => _safeAction(() => context.push('/support')), 
          ),
          _buildSettingTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () => _safeAction(() => print("Privacy tapped")),
          ),

          const SizedBox(height: AppConstants.paddingXL),
          
          TextButton(
            onPressed: () => _safeAction(() => context.go('/login')),
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
              style: theme.textTheme.labelSmall, 
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: theme.textTheme.bodyMedium) : null,
        trailing: Icon(Icons.chevron_right, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radiusMedium)),
      ),
    );
  }
}
