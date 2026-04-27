import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/button.dart';
import '../data/report_insight_model.dart';
import '../../../core/constants/app_constants.dart';

class InsightsScreen extends StatelessWidget {
  final ReportInsightModel insightData; 

  const InsightsScreen({super.key, required this.insightData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Report Insights'), 
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(insightData.reportTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppConstants.paddingXS),
            Text('Analyzed on ${insightData.date}', style: theme.textTheme.labelSmall),
            const SizedBox(height: AppConstants.paddingXL),

            if (insightData.alerts.isNotEmpty) ...[
              ...insightData.alerts.map((alert) => Padding(
                    padding: const EdgeInsets.only(bottom: AppConstants.paddingL),
                    child: _buildAlertCard(
                      context: context,
                      icon: alert.isWarning ? Icons.warning_amber_rounded : Icons.info_outline,
                      title: alert.title,
                      message: alert.message,
                      isWarning: alert.isWarning,
                    ),
                  )),
              const SizedBox(height: AppConstants.paddingS),
            ],

            Text('What it means', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingM),
            _buildInfoCard(context, insightData.explanation),
            const SizedBox(height: AppConstants.paddingXL),

            Text('Action Plan', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingM),
            ...insightData.actions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.paddingS),
                  child: _buildActionItem(context, action.title, action.description),
                )),
            
            const SizedBox(height: AppConstants.paddingXL),
            ShadcnButton(
              text: 'Save to Dashboard',
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }  
  

  Widget _buildAlertCard({
    required BuildContext context, 
    required IconData icon, 
    required String title, 
    required String message, 
    bool isWarning = false
  }) {
    final theme = Theme.of(context);
    final baseColor = isWarning ? Colors.orange : theme.colorScheme.primary;
    
    final bgColor = baseColor.withOpacity(0.1); 
    final borderColor = baseColor.withOpacity(0.3);

    return Container(
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: baseColor),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(color: baseColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppConstants.paddingXS),
                Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String text) {
    final theme = Theme.of(context);
    
    return Container(
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Text(text, style: theme.textTheme.bodyMedium),
    );
  }

  Widget _buildActionItem(BuildContext context, String title, String description) {
    final theme = Theme.of(context);

    return Container(
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: AppConstants.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppConstants.paddingXS),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
