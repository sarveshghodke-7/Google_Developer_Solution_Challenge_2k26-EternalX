import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/medical_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Helper to handle safe navigation
  void _safeNavigate(BuildContext context, String route) {
    Future.microtask(() => context.push(route));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.surface, 
            child: Icon(Icons.person_outline, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppConstants.paddingL),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppConstants.paddingXL, 
          right: AppConstants.paddingXL, 
          top: AppConstants.paddingXL, 
          bottom: 30.0, 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,\nMiss Sarvesh',
              style: theme.textTheme.headlineMedium?.copyWith(
                height: 1.1, 
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
            
            MedicalCard.primary(
              title: 'Analyze New Report',
              subtitle: 'Upload results for AI insights',
              icon: Icons.add_circle_outline,
              onTap: () => _safeNavigate(context, '/upload'),
            ),
            
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Health Trends', style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => _safeNavigate(context, '/timeline'),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingM),
            
            MedicalCard.trend(
                title: 'LDL Cholesterol',
                subtitle: 'Down 12% since Jan',
                icon: Icons.trending_down,
                onTap: () => _safeNavigate(context, '/timeline'),
            ),
            
            const SizedBox(height: 32),

            Text('Current Challenge', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingM),
            
            MedicalCard.progress(
                title: '7-Day No Sugar',
                daysLeft: '4 days left',
                progress: 0.42,
                onTap: () => _safeNavigate(context, '/campaigns'),
            ),
            
            const SizedBox(height: 32),
            
            Text('Quick Access', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingL),
            
            GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingL,
                mainAxisSpacing: AppConstants.paddingL,
                childAspectRatio: 1.5,
                children: [
                  MedicalCard.quick(
                    title: 'Meds', 
                    icon: Icons.medication_outlined,
                    onTap: () => _safeNavigate(context, '/medications'),
                  ),
                  MedicalCard.quick(
                    title: 'Visits', 
                    icon: Icons.calendar_month_outlined, 
                    onTap: () => _safeNavigate(context, '/visits'),
                  ),
                  MedicalCard.quick(
                    title: 'Support', 
                    icon: Icons.chat_bubble_outline, 
                    onTap: () => _safeNavigate(context, '/support'),
                  ),
                  MedicalCard.quick(
                    title: 'Settings', 
                    icon: Icons.settings_outlined, 
                    onTap: () => _safeNavigate(context, '/settings'),
                  ),
                ],
            ),          
          ],
        ),
      ),
    );
  }
}
