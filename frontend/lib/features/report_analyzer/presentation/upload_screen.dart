import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/utils/file_storage_service.dart'; 
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_service.dart'; 
import '../data/report_insight_model.dart';
import '../../../core/utils/local_storage_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FileStorageService _fileStorageService = FileStorageService();
  File? _selectedReport;
  bool _isLoading = false;
  bool _isAnalyzing = false;
  
  Future<void> _processReport() async {
    if (_selectedReport == null) return;

    setState(() => _isAnalyzing = true);
    try {
      final ReportInsightModel result = await ApiService().analyzeReport(_selectedReport!);
      await LocalStorageService().saveLatestReport(result);
      if (mounted) {
        context.push('/insights', extra: result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

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
    final theme = Theme.of(context); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report'), 
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Report Analyzer', style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Upload your lab results (CBC, cholesterol, etc.) as a PDF or Image. We will extract the key parameters and explain them simply.',
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4), 
            ),
            const SizedBox(height: AppConstants.paddingXL),
            
            GestureDetector(
              onTap: _isLoading || _isAnalyzing ? null : _handleFileSelection, // Disable while analyzing
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, 
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: _selectedReport != null 
                        ? theme.colorScheme.primary 
                        : theme.dividerColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isLoading)
                      CircularProgressIndicator(color: theme.colorScheme.primary)
                    else ...[
                      Icon(
                        _selectedReport != null ? Icons.check_circle : Icons.upload_file,
                        size: 48,
                        color: _selectedReport != null 
                            ? theme.colorScheme.primary 
                            : theme.colorScheme.onSurface.withOpacity(0.5), 
                      ),
                      const SizedBox(height: AppConstants.paddingL),
                      Text(
                        _selectedReport != null ? 'File Selected' : 'Tap to browse files',
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Text(
                        fileName ?? 'Supports PDF, JPG, or PNG',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            _isAnalyzing
              ? const Center(child: CircularProgressIndicator())
              : ShadcnButton(
                  text: 'Analyze Report',
                  onPressed: _selectedReport != null ? _processReport : () {}, 
                ),
          ],
        ),
      ),
    );
  }
}
