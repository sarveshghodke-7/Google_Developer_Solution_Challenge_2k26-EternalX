import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/input.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appointments = [
      {'doc': 'Dr. Sarah Jenkins', 'type': 'Cardiology Follow-up', 'date': 'Oct 24, 2026', 'time': '10:00 AM'},
      {'doc': 'Dr. Mark Sloan', 'type': 'Annual Physical', 'date': 'Nov 12, 2026', 'time': '2:30 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Future.microtask(() => context.pop()),
        ),
        title: const Text('Appointments'),
      ),
      body: ListView(
        padding: AppConstants.screenPadding,
        children: [
          Text('Upcoming Visits', style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppConstants.paddingS),
          Text('Manage your scheduled appointments.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingXL),
          ...appointments.map((appt) => _buildAppointmentCard(context, appt)),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, String> appt) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: Icon(Icons.person, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: AppConstants.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt['doc']!, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(appt['type']!, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(theme, Icons.calendar_today, appt['date']!),
              _buildInfoRow(theme, Icons.access_time, appt['time']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// --- The Booking Sheet ---
void showBookVisitSheet(BuildContext context) {
  final theme = Theme.of(context);
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.only(
        top: 24, left: 24, right: 24,
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
          Text('Book Appointment', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 24),
          const ShadcnInput(hintText: 'Doctor or Clinic Name'),
          const SizedBox(height: 16),
          const ShadcnInput(hintText: 'Reason for visit (e.g., Blood Test)'),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildPickerButton(
                  context, 
                  Icons.calendar_month, 
                  'Select Date', 
                  () => showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), 
                    lastDate: DateTime(2030)
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Time Picker Button
              Expanded(
                child: _buildPickerButton(
                  context, 
                  Icons.access_time, 
                  'Select Time', 
                  () => showTimePicker(context: context, initialTime: TimeOfDay.now()),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          ShadcnButton(
            text: 'Confirm Appointment',
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Appointment requested!')),
              );
            },
          ),
        ],
      ),
    ),
  );
}

Widget _buildPickerButton(BuildContext context, IconData icon, String label, VoidCallback onTap) {
  final theme = Theme.of(context);
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 18),
          const SizedBox(width: 8),
          Flexible(child: Text(label, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
        ],
      ),
    ),
  );
}
