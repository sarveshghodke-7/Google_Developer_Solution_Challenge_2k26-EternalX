import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/input.dart';
import '../../../core/network/api_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
final ValueNotifier<int> refreshVisitsNotifier = ValueNotifier(0);

class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});

  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  List<dynamic> visits = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchVisits();
    refreshVisitsNotifier.addListener(_fetchVisits);
  }

  @override
  void dispose() {
    refreshVisitsNotifier.removeListener(_fetchVisits);
    super.dispose();
  }

  Future<void> _fetchVisits() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final data = await _apiService.fetchVisits(currentUserId);
      if (mounted) {
        setState(() {
          visits = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading visits: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Appointments'),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : visits.isEmpty
            ? const Center(child: Text('No upcoming appointments.'))
            : ListView(
                padding: AppConstants.screenPadding,
                children: [
                  Text('Upcoming Visits', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: AppConstants.paddingS),
                  Text('Manage your scheduled appointments.', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: AppConstants.paddingXL),
                  ...visits.map((appt) => _buildAppointmentCard(context, appt as Map<String, dynamic>)),
                ],
              ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context, Map<String, dynamic> appt) {
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
                    Text(appt['doctorName'] ?? 'Unknown Doctor', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text(appt['specialty'] ?? 'General', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM), 
            child: Divider(height: 1)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(theme, Icons.calendar_today, appt['date'] ?? 'No Date'),
              _buildInfoRow(theme, Icons.access_time, appt['time'] ?? 'No Time'),
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

class AddVisitSheet extends StatefulWidget {
  const AddVisitSheet({super.key});

  @override
  State<AddVisitSheet> createState() => _AddVisitSheetState();
}

class _AddVisitSheetState extends State<AddVisitSheet> {
  final _docController = TextEditingController();
  final _specController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

 Future<void> _saveVisit() async {
    if (_docController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ApiService().addVisit({
        'userId': currentUserId,
        'doctorName': _docController.text,
        'specialty': _specController.text,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!), 
        'time': _selectedTime!.format(context),
        'notes': '', 
      });

      if (mounted) {
        Navigator.pop(context);
        refreshVisitsNotifier.value++; 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment saved!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
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
          ShadcnInput(
            hintText: 'Doctor or Clinic Name', 
            controller: _docController
          ),
          const SizedBox(height: 16),
          ShadcnInput(
            hintText: 'Reason for visit (e.g., Blood Test)', 
            controller: _specController
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildPickerButton(
                  context, 
                  Icons.calendar_month, 
                  _selectedDate == null 
                      ? 'Select Date' 
                      : DateFormat('MMM d, yyyy').format(_selectedDate!), 
                  () async {
                    final date = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(2030)
                    );
                    if (date != null) setState(() => _selectedDate = date);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPickerButton(
                  context, 
                  Icons.access_time, 
                  _selectedTime == null ? 'Select Time' : _selectedTime!.format(context), 
                  () async {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                    if (time != null) setState(() => _selectedTime = time);
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _isSaving 
            ? const Center(child: CircularProgressIndicator())
            : ShadcnButton(
                text: 'Confirm Appointment',
                onPressed: _saveVisit,
              ),
        ],
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
}

void showBookVisitSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddVisitSheet(),
  );
}
