import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/timeline_model.dart'; 

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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Health Timeline', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Health Trends', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Track how your $selectedMetric is changing over time.', 
              style: const TextStyle(color: AppTheme.textMuted)),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedMetric,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
                  items: widget.metricsData.keys
                      .map((metric) => DropdownMenuItem(value: metric, child: Text(metric)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedMetric = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildDynamicChart(currentData),
            
            const SizedBox(height: 32),
            const Text('Past Reports', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...currentData.history.map((report) => _buildHistoryItem(
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

  Widget _buildDynamicChart(TimelineModel data) {
    return Container(
      height: 300,
      padding: const EdgeInsets.only(right: 24, left: 8, top: 24, bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
            getDrawingHorizontalLine: (value) => FlLine(color: AppTheme.borderColor, strokeWidth: 1),
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
                    child: Text(point.label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
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
              color: AppTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: AppTheme.primaryColor,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String date, String title, String subtitle, bool isPositive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.surfaceColor, borderRadius: BorderRadius.circular(6)),
            child: const Icon(Icons.insert_drive_file_outlined, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(date, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPositive ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
