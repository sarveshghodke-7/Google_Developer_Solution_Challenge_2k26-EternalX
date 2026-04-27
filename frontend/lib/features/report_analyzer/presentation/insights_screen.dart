import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/button.dart';
import '../data/report_insight_model.dart';
import '../../../core/constants/app_constants.dart';

class InsightsScreen extends StatelessWidget {
  final ReportInsightModel insightData; 

  const InsightsScreen({super.key, required this.insightData});

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
            Text(insightData.reportTitle, style: const TextStyle(fontSize: AppTypography.titleLarge, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Analyzed on ${insightData.date}', style: const TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 24),

            if (insightData.alerts.isNotEmpty) ...[
              ...insightData.alerts.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildAlertCard(
                      context: context,
                      icon: alert.isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                      title: alert.title,
                      message: alert.message,
                      isWarning: alert.isWarning,
                    ),
                  )),
              const SizedBox(height: 8),
            ],

            const Text('What it means', style: TextStyle(fontSize: AppTypography.titleMedium, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoCard(insightData.explanation),
            const SizedBox(height: 24),

            const Text('Action Plan', style: TextStyle(fontSize: AppTypography.titleMedium, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...insightData.actions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _buildActionItem(action.title, action.description),
                )),
            
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
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: AppTypography.bodyLarge)),
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
      child: Text(text, style: const TextStyle(height: 1.5, fontSize: AppTypography.bodyMedium)),
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppTypography.bodyMedium)),
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
