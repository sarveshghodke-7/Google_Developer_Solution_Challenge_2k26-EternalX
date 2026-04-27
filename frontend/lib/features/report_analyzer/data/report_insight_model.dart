class ReportInsightModel {
  final List<dynamic> alerts;
  final List<dynamic> parameters;
  final List<dynamic> recommendations;

  ReportInsightModel({
    required this.alerts,
    required this.parameters,
    required this.recommendations,
  });

  factory ReportInsightModel.fromJson(Map<String, dynamic> json) {
    return ReportInsightModel(
      alerts: json['alerts'] ?? [],
      parameters: json['parameters'] ?? [],
      recommendations: json['recommendations'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alerts': alerts,
      'parameters': parameters,
      'recommendations': recommendations,
    };
  }
}
