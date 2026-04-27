import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/button.dart';
import '../../../core/utils/file_storage_service.dart';
import '../../../core/services/api_service.dart';
import '../data/report_insight_model.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final FileStorageService _fileStorageService = FileStorageService();

  File? _selectedReport;
  bool _isPickingFile = false;
  bool _isAnalyzing = false;
  String? _errorMessage;

  // ─── File Selection ────────────────────────────────────────────────────────

  Future<void> _handleFileSelection() async {
    setState(() {
      _isPickingFile = true;
      _errorMessage = null;
    });

    final File? file = await _fileStorageService.pickAndSaveReport();

    setState(() {
      _isPickingFile = false;
      if (file != null) _selectedReport = file;
    });
  }

  // ─── API Call ──────────────────────────────────────────────────────────────

  Future<void> _handleAnalyze() async {
    if (_selectedReport == null) return;

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final json = await ApiService.instance.analyzeReport(_selectedReport!);

      // Parse the API response into the model the InsightsScreen expects
      final insightData = ReportInsightModel.fromJson(json);

      if (!mounted) return;

      // Navigate to insights, passing the real data via router extra
      context.push('/insights', extra: insightData);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  // ─── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final fileName = _selectedReport?.path.split('/').last ??
        _selectedReport?.path.split('\\').last;
    final bool isBusy = _isPickingFile || _isAnalyzing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Report Analyzer',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Upload your lab results (CBC, cholesterol, etc.) as a PDF or Image. '
              'Our AI will extract the key parameters and explain them in plain language.',
              style: TextStyle(color: AppTheme.textMuted, height: 1.4),
            ),
            const SizedBox(height: 32),

            // ── Drop Zone ──────────────────────────────────────────────────
            GestureDetector(
              onTap: isBusy ? null : _handleFileSelection,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedReport != null
                        ? AppTheme.primaryColor
                        : AppTheme.borderColor,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isPickingFile)
                      const CircularProgressIndicator(
                          color: AppTheme.primaryColor)
                    else ...[
                      Icon(
                        _selectedReport != null
                            ? Icons.check_circle
                            : Icons.upload_file,
                        size: 48,
                        color: _selectedReport != null
                            ? AppTheme.primaryColor
                            : AppTheme.textMuted,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedReport != null
                            ? 'File Selected'
                            : 'Tap to browse files',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName ?? 'Supports PDF, JPG, or PNG (max 25 MB)',
                        style: const TextStyle(
                            color: AppTheme.textMuted, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Error ──────────────────────────────────────────────────────
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: Colors.red.shade700, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                            color: Colors.red.shade700, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            // ── Analyze Button ─────────────────────────────────────────────
            if (_isAnalyzing) ...[
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppTheme.primaryColor),
                    SizedBox(height: 16),
                    Text(
                      'Analyzing your report with AI…\nThis may take up to 30 seconds.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textMuted, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else
              ShadcnButton(
                text: 'Analyze Report',
                onPressed: _selectedReport != null ? _handleAnalyze : null,
              ),
          ],
        ),
      ),
    );
  }
}
