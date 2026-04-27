import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
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
    final bool isPrimary = variant == MedicalCardVariant.primary;
    final Color bgColor = isPrimary ? AppTheme.primaryColor : (variant == MedicalCardVariant.progress ? AppTheme.surfaceColor : AppTheme.backgroundColor);
    final Color contentColor = isPrimary ? Colors.white : AppTheme.textPrimary;
    final Border? border = isPrimary ? null : Border.all(color: AppTheme.borderColor);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: border,
        boxShadow: isPrimary ? [BoxShadow(color: AppTheme.primaryColor.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          child: Padding(
            padding: AppConstants.cardPadding,
            child: _buildContent(contentColor),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    switch (variant) {
      case MedicalCardVariant.primary:
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
                  if (subtitle != null) Text(subtitle!, style: TextStyle(color: color.withOpacity(0.8), fontSize: 14)),
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
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ],
        );

      case MedicalCardVariant.trend:
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(AppConstants.radiusSmall)),
              child: Icon(icon, color: Colors.teal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (subtitle != null) Text(subtitle!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_right, color: AppTheme.textMuted),
          ],
        );

      case MedicalCardVariant.progress:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (trailingText != null) Text(trailingText!, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w600, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress ?? 0,
              backgroundColor: AppTheme.borderColor,
              color: AppTheme.primaryColor,
              minHeight: 6,
              borderRadius: BorderRadius.circular(AppConstants.radiusExtraSmall),
            ),
          ],
        );
    }
  }
}
