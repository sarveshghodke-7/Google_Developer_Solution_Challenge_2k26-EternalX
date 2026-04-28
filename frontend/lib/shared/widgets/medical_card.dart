import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

enum MedicalCardVariant { primary, quick, trend, progress }

class MedicalCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final MedicalCardVariant variant;
  final double? progress; 
  final String? trailingText; 

  const MedicalCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.variant = MedicalCardVariant.primary,
    this.progress,
    this.trailingText,
  });

  factory MedicalCard.primary({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) => MedicalCard(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        variant: MedicalCardVariant.primary,
      );

  factory MedicalCard.quick({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) => MedicalCard(
        title: title,
        icon: icon,
        onTap: onTap,
        variant: MedicalCardVariant.quick,
      );

  factory MedicalCard.trend({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) => MedicalCard(
        title: title,
        subtitle: subtitle,
        icon: icon,
        onTap: onTap,
        variant: MedicalCardVariant.trend,
      );

  factory MedicalCard.progress({
    required String title,
    required String daysLeft,
    required double progress,
    required VoidCallback onTap,
  }) => MedicalCard(
        title: title,
        trailingText: daysLeft,
        progress: progress,
        icon: Icons.timer_outlined,
        onTap: onTap,
        variant: MedicalCardVariant.progress,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isPrimary = variant == MedicalCardVariant.primary;
    
    final Color bgColor = isPrimary 
        ? theme.colorScheme.primary 
        : theme.colorScheme.surface; 
        
    final Color contentColor = isPrimary 
        ? theme.colorScheme.onPrimary 
        : theme.colorScheme.onSurface;
        
    final Border? border = isPrimary 
        ? null 
        : Border.all(color: theme.dividerColor.withOpacity(0.1));

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: border,
        boxShadow: isPrimary 
            ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] 
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: AppConstants.cardPadding,
            child: _buildContent(context, contentColor, theme), 
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color color, ThemeData theme) {
    switch (variant) {
      case MedicalCardVariant.primary:
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
                  if (subtitle != null) 
                    Text(subtitle!, style: theme.textTheme.bodyMedium?.copyWith(color: color.withOpacity(0.8))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        );

      case MedicalCardVariant.quick:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppConstants.paddingS),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(color: color, fontSize: 13)), // Using adaptive color
          ],
        );

      case MedicalCardVariant.trend:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1), 
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall)
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: AppConstants.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                  if (subtitle != null) 
                    Text(subtitle!, style: theme.textTheme.labelSmall), 
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right, color: theme.colorScheme.onSurface.withOpacity(0.5)),
          ],
        );

      case MedicalCardVariant.progress:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                if (trailingText != null) 
                  Text(trailingText!, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: AppConstants.paddingM),
            LinearProgressIndicator(
              value: progress ?? 0,
              backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
              color: theme.colorScheme.primary,
              minHeight: 6,
              borderRadius: BorderRadius.circular(AppConstants.radiusExtraSmall),
            ),
          ],
        );
    }
  }
}
