import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/medical_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName, style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppTheme.surfaceColor,
            child: Icon(Icons.person_outline, size: 20, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning,\nMiss Sarvesh',
              style: TextStyle(fontSize: AppTypography.headingMedium, fontWeight: FontWeight.bold, height: 1.1, letterSpacing: -0.5),
            ),
            const SizedBox(height: 24),
            MedicalCard.primary(
              title: 'Analyze New Report',
              subtitle: 'Upload results for AI insights',
              icon: Icons.add_circle_outline,
              onTap: () => context.push('/upload'),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Health Trends', style: TextStyle(fontSize: AppTypography.titleMedium, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => context.push('/timeline'),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MedicalCard.trend(
                title: 'LDL Cholesterol',
                subtitle: 'Down 12% since Jan',
                icon: Icons.trending_down,
                onTap: () => context.push('/timeline'),
            ),
            const SizedBox(height: 32),

            const Text('Current Challenge', style: TextStyle(fontSize: AppTypography.titleMedium, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            MedicalCard.progress(
                title: '7-Day No Sugar',
                daysLeft: '4 days left',
                progress: 0.42,
                onTap: () => context.push('/campaigns'),
            ),
           
            const SizedBox(height: 32),
            
            const Text('Quick Access', style: TextStyle(fontSize: AppTypography.titleMedium, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  MedicalCard.quick(title: 'Meds', icon: Icons.medication_outlined, onTap: () {}),
                  MedicalCard.quick(title: 'Visits', icon: Icons.calendar_month_outlined, onTap: () {}),
                  MedicalCard.quick(title: 'Support', icon: Icons.chat_bubble_outline, onTap: () {}),
                  MedicalCard.quick(title: 'Settings', icon: Icons.settings_outlined, onTap: () {}),
                ],
            ),          
          ],
        ),
      ),
    );
  }

}
