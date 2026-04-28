import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../data/timeline_model.dart'; 
import '../../../core/constants/app_constants.dart';

class TimelineScreen extends StatefulWidget {
  final Map<String, TimelineModel> metricsData;

  const TimelineScreen({super.key, required this.metricsData});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  late String selectedMetric;

  @override
  void initState() {
    super.initState();
    selectedMetric = widget.metricsData.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    final currentData = widget.metricsData[selectedMetric]!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Timeline'), 
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Health Trends', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Track how your $selectedMetric is changing over time.', 
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppConstants.paddingXL),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMetric,
                  isExpanded: true,
                  dropdownColor: theme.colorScheme.surface, 
                  icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                  items: widget.metricsData.keys
                      .map((metric) => DropdownMenuItem(
                            value: metric, 
                            child: Text(metric, style: theme.textTheme.bodyLarge),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedMetric = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),

            _buildDynamicChart(context, currentData),
            
            const SizedBox(height: AppConstants.paddingXL),
            Text('Past Reports', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingL),
            
            ...currentData.history.map((report) => _buildHistoryItem(
              context,
              report.date, 
              report.title, 
              report.changeText, 
              report.isImprovement
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicChart(BuildContext context, TimelineModel data) {
    final theme = Theme.of(context);

    return Container(
      height: 300,
      padding: const EdgeInsets.only(right: 24, left: 8, top: 24, bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(
              color: theme.dividerColor.withOpacity(0.1), 
              strokeWidth: 1
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final point = data.dataPoints.firstWhere((p) => p.x == value, orElse: () => TimelinePoint(x: -1, y: 0, label: ''));
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(point.label, style: theme.textTheme.labelSmall),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.dataPoints.map((p) => FlSpot(p.x, p.y)).toList(),
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: theme.colorScheme.surface,
                  strokeWidth: 2,
                  strokeColor: theme.colorScheme.primary,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, String date, String title, String subtitle, bool isPositive) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall)
            ),
            child: Icon(Icons.insert_drive_file_outlined, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: AppConstants.paddingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppConstants.paddingXS),
                Text(date, style: theme.textTheme.labelSmall),
              ],
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isPositive 
                  ? (isDark ? Colors.green.shade400 : Colors.green.shade700) 
                  : (isDark ? Colors.orange.shade400 : Colors.orange.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
