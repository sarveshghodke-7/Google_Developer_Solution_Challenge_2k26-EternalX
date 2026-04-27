import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/input.dart';

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
            decoration: isTaken ? TextDecoration.lineThrough : null,
            color: isTaken ? theme.colorScheme.onSurface.withOpacity(0.5) : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppConstants.paddingXS),
          child: Text('${med['dosage']} • ${med['time']}', style: theme.textTheme.labelSmall),
        ),
        trailing: IconButton(
          icon: Icon(
            isTaken ? Icons.check_circle : Icons.circle_outlined,
            color: isTaken ? Colors.green : theme.dividerColor,
            size: 28,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}

void showAddMedicationSheet(BuildContext context) {
  final theme = Theme.of(context);
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24, 
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('New Medication', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Enter the details for your prescription.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          const ShadcnInput(hintText: 'Medication Name (e.g., Lisinopril)'),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(child: ShadcnInput(hintText: 'Dosage (e.g., 10)')),
              const SizedBox(width: 16),
              const Expanded(child: ShadcnInput(hintText: 'Unit (e.g., mg)')),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              await showTimePicker(context: context, initialTime: TimeOfDay.now());
            },
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 12),
                  Text('Select Reminder Time', style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          ShadcnButton(
            text: 'Save Medication',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medication saved locally!')),
              );
            },
          ),
        ],
      ),
    ),
  );
}
