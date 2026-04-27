import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeMeds = [
      {'name': 'Atorvastatin', 'dosage': '20mg', 'frequency': '1 pill daily', 'time': '8:00 AM', 'taken': true},
      {'name': 'Lisinopril', 'dosage': '10mg', 'frequency': '1 pill daily', 'time': '8:00 AM', 'taken': true},
      {'name': 'Metformin', 'dosage': '500mg', 'frequency': '2 pills daily', 'time': '8:00 PM', 'taken': false},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Future.microtask(() => context.pop()),
        ),
        title: const Text('Medications'),
      ),
      body: ListView(
        padding: AppConstants.screenPadding,
        children: [
          Text('Today\'s Schedule', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'Track your daily prescriptions and supplements.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConstants.paddingXL),

          ...activeMeds.map((med) => _buildMedicationCard(context, med)),
        ],
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Map<String, dynamic> med) {
    final theme = Theme.of(context);
    final isTaken = med['taken'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: AppConstants.cardPadding,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isTaken ? Colors.green.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Icon(
            Icons.medication_outlined,
            color: isTaken ? Colors.green : theme.colorScheme.primary,
          ),
        ),
        title: Text(
          med['name'],
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: isTaken ? TextDecoration.lineThrough : null, // Crosses out taken meds!
            color: isTaken ? theme.colorScheme.onSurface.withOpacity(0.5) : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppConstants.paddingXS),
          child: Text(
            '${med['dosage']} • ${med['time']}',
            style: theme.textTheme.labelSmall,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isTaken ? Icons.check_circle : Icons.circle_outlined,
            color: isTaken ? Colors.green : theme.dividerColor,
            size: 28,
          ),
          onPressed: () {
            // TODO: API call to mark as taken
          },
        ),
      ),
    );
  }
}
