class TimelineModel {
  final String metricName;
  final String unit;
  final List<TimelinePoint> dataPoints;
  final List<PastReportSummary> history;

  TimelineModel({
    required this.metricName,
    required this.unit,
    required this.dataPoints,
    required this.history,
  });

  factory TimelineModel.fromJson(Map<String, dynamic> json) {
    return TimelineModel(
      metricName: json['metricName'] ?? '',
      unit: json['unit'] ?? '',
      dataPoints: (json['dataPoints'] as List)
          .map((i) => TimelinePoint.fromJson(i))
          .toList(),
      history: (json['history'] as List)
          .map((i) => PastReportSummary.fromJson(i))
          .toList(),
    );
  }
}

class TimelinePoint {
  final double x; // Represents time (e.g., Month index 0, 1, 2)
  final double y; // The value (e.g., 160 mg/dL)
  final String label; // e.g., "Jan"

  TimelinePoint({required this.x, required this.y, required this.label});

  factory TimelinePoint.fromJson(Map<String, dynamic> json) {
    return TimelinePoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      label: json['label'] ?? '',
    );
  }
}

class PastReportSummary {
  final String date;
  final String title;
  final String changeText;
  final bool isImprovement;

  PastReportSummary({
    required this.date,
    required this.title,
    required this.changeText,
    required this.isImprovement,
  });

  factory PastReportSummary.fromJson(Map<String, dynamic> json) {
    return PastReportSummary(
      date: json['date'] ?? '',
      title: json['title'] ?? '',
      changeText: json['changeText'] ?? '',
      isImprovement: json['isImprovement'] ?? false,
    );
  }
}
