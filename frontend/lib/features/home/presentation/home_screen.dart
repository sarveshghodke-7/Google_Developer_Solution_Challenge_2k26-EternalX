import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Good morning,\nJohn Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(context, Icons.calendar_month_outlined, 'Appointments',() {print('Appointments clicked');}),
                  _buildDashboardCard(context, Icons.medical_information_outlined, 'Records',(){}),
                  _buildDashboardCard(context, Icons.medication_outlined, 'Prescriptions',(){}),
                  _buildDashboardCard(context,Icons.chat_bubble_outline,'Messages',() {context.push('/upload');},),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderColor),
          ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),

            // 2. Pass it to the InkWell here
            onTap: onTap, 

            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Icon(icon, size: 28, color: AppTheme.primaryColor),
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ],
                ),
              ),
            ),
          ),
          );
  }
}
