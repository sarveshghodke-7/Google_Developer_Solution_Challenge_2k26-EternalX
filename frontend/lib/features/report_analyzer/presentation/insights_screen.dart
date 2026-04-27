import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/button.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Report Insights', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lipid Panel Blood Test', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Analyzed on April 27, 2026', style: TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 24),
            _buildAlertCard(
              context: context,
              icon: Icons.warning_amber_rounded,
              title: 'Attention Needed',
              message: 'Your LDL Cholesterol (Bad Cholesterol) is elevated at 160 mg/dL.',
              isWarning: true,
            ),
            const SizedBox(height: 24),
            const Text('What it means', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoCard(
              'Cholesterol is a waxy substance in your blood. While your body needs it to build cells, having too much LDL (bad) cholesterol can cause buildup in your arteries. This increases the risk of heart disease over time. Your levels are slightly above the normal range (under 100 mg/dL).',
            ),
            const SizedBox(height: 24),
            const Text('Action Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildActionItem('Dietary Changes', 'Reduce saturated fats (found in red meat and full-fat dairy) and eliminate trans fats.'),
            const SizedBox(height: 8),
            _buildActionItem('Increase Omega-3s', 'Eat more foods rich in omega-3 fatty acids like salmon, walnuts, and flaxseeds.'),
            const SizedBox(height: 8),
            _buildActionItem('Exercise', 'Aim for 30 minutes of moderate exercise, like brisk walking, 5 times a week.'),
            
            const SizedBox(height: 32),
            ShadcnButton(
              text: 'Save to Dashboard',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI Helper Widgets for that clean look ---

  Widget _buildAlertCard({required BuildContext context, required IconData icon, required String title, required String message, bool isWarning = false}) {
    final color = isWarning ? Colors.orange.shade800 : AppTheme.primaryColor;
    final bgColor = isWarning ? Colors.orange.shade50 : AppTheme.surfaceColor;
    final borderColor = isWarning ? Colors.orange.shade200 : AppTheme.borderColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(message, style: TextStyle(color: AppTheme.textPrimary, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Text(text, style: const TextStyle(height: 1.5, fontSize: 15)),
    );
  }

  Widget _buildActionItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: AppTheme.textMuted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
