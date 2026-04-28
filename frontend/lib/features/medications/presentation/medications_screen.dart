import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/input.dart';
import '../../../core/network/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
final ValueNotifier<int> refreshMedsNotifier = ValueNotifier(0);

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  List<dynamic> activeMeds = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchMedications();
    refreshMedsNotifier.addListener(_fetchMedications);
  }

  @override
  void dispose() {
    refreshMedsNotifier.removeListener(_fetchMedications);
    super.dispose();
  }

  Future<void> _fetchMedications() async {
    setState(() => isLoading = true);
    try {
      final meds = await _apiService.fetchMedications(currentUserId);
      
      if (mounted) {
        setState(() {
          activeMeds = meds;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading medications: $e')),
        );
      }
    }
  }

  void _toggleTaken(int index) {
    setState(() {
      final isTaken = activeMeds[index]['taken'] ?? false;
      activeMeds[index]['taken'] = !isTaken;
    });
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
        title: const Text('Medications'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : activeMeds.isEmpty
              ? const Center(child: Text('No medications added yet.'))
              : ListView(
                  padding: AppConstants.screenPadding,
                  children: [
                    Text('Today\'s Schedule', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppConstants.paddingS),
                    Text(
                      'Track your daily prescriptions and supplements.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppConstants.paddingXL),
                    ...activeMeds.asMap().entries.map((entry) => 
                      _buildMedicationCard(context, entry.value, entry.key)
                    ),
                  ],
                ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Map<String, dynamic> med, int index) {
    final theme = Theme.of(context);
    final isTaken = med['taken'] ?? false; 

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
          med['name'] ?? 'Unknown Med',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: isTaken ? TextDecoration.lineThrough : null,
            color: isTaken ? theme.colorScheme.onSurface.withOpacity(0.5) : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppConstants.paddingXS),
          child: Text('${med['dosage']} • ${med['reminderTime']}', style: theme.textTheme.labelSmall),
        ),
        trailing: IconButton(
          icon: Icon(
            isTaken ? Icons.check_circle : Icons.circle_outlined,
            color: isTaken ? Colors.green : theme.dividerColor,
            size: 28,
          ),
          onPressed: () => _toggleTaken(index),
        ),
      ),
    );
  }
}

class AddMedicationSheet extends StatefulWidget {
  const AddMedicationSheet({super.key});

  @override
  State<AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<AddMedicationSheet> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _unitController = TextEditingController();
  final ApiService _apiService = ApiService();
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  Future<void> _saveMedication() async {
    if (_nameController.text.isEmpty || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name and select a time.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final formattedTime = _selectedTime!.format(context);
    final fullDosage = '${_dosageController.text}${_unitController.text}';

    try {
      await _apiService.addMedication({
        'userId': currentUserId,
        'name': _nameController.text,
        'dosage': fullDosage,
        'frequency': 'Daily',
        'reminderTime': formattedTime,
      });

      if (mounted) {
        Navigator.pop(context); 
        refreshMedsNotifier.value++; 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medication saved to cloud!')),
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
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _unitController.dispose();
    super.dispose();
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
          Text('New Medication', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Enter the details for your prescription.', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          
          ShadcnInput(
            hintText: 'Medication Name (e.g., Lisinopril)',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ShadcnInput(
                  hintText: 'Dosage (e.g., 10)',
                  controller: _dosageController,
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ShadcnInput(
                  hintText: 'Unit (e.g., mg)',
                  controller: _unitController,
                )
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          InkWell(
            onTap: () async {
              final time = await showTimePicker(
                context: context, 
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() => _selectedTime = time);
              }
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
                  Text(
                    _selectedTime == null 
                        ? 'Select Reminder Time' 
                        : 'Reminder set for ${_selectedTime!.format(context)}', 
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: _selectedTime != null ? FontWeight.bold : FontWeight.normal,
                    )
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          
          _isSaving 
            ? const Center(child: CircularProgressIndicator())
            : ShadcnButton(
                text: 'Save Medication',
                onPressed: _saveMedication,
              ),
        ],
      ),
    );
  }
}

void showAddMedicationSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AddMedicationSheet(),
  );
}
