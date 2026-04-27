import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

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
          onPressed: () => Future.microtask(()=>context.pop()),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(appt['date']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(appt['time']!, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
