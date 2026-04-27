import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/utils/file_storage_service.dart'; 
import '../../../core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FileStorageService _fileStorageService = FileStorageService();
  File? _selectedReport;
  bool _isLoading = false;

  Future<void> _handleFileSelection() async {
    setState(() => _isLoading = true);
    final File? file = await _fileStorageService.pickAndSaveReport();
    if (file != null) {
      setState(() {
        _selectedReport = file;
      });
      print('File safely stored at: ${file.path}');
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final fileName = _selectedReport?.path.split('/').last;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Report Analyzer', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Upload your lab results (CBC, cholesterol, etc.) as a PDF or Image. We will extract the key parameters and explain them simply.',
              style: TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
            const SizedBox(height: 32),
            
            GestureDetector(
              onTap: _isLoading ? null : _handleFileSelection,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedReport != null ? AppTheme.primaryColor : AppTheme.borderColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator(color: AppTheme.primaryColor)
                    else ...[
                      Icon(
                        _selectedReport != null ? Icons.check_circle : Icons.upload_file,
                        size: 48,
                        color: _selectedReport != null ? AppTheme.primaryColor : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedReport != null ? 'File Selected' : 'Tap to browse files',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppTypography.bodyLarge),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName ?? 'Supports PDF, JPG, or PNG',
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: AppTypography.bodyMedium),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            ShadcnButton(
              text: 'Analyze Report',
              onPressed: _selectedReport != null 
                  ? () {
                      context.push('/insights');
                    }
                  : () {}, 
            ),
          ],
        ),
      ),
    );
  }
}
