class ReportInsightModel {
  final String reportTitle;
  final String date;
  final String explanation;
  final List<AlertModel> alerts;
  final List<ActionModel> actions;

  ReportInsightModel({
    required this.reportTitle,
    required this.date,
    required this.explanation,
    required this.alerts,
    required this.actions,
  });

  factory ReportInsightModel.fromJson(Map<String, dynamic> json) {
    return ReportInsightModel(
      reportTitle: json['reportTitle'] ?? 'Unknown Report',
      date: json['date'] ?? '',
      explanation: json['explanation'] ?? '',
      alerts: (json['alerts'] as List<dynamic>?)
              ?.map((e) => AlertModel.fromJson(e))
              .toList() ?? [],
      actions: (json['actions'] as List<dynamic>?)
              ?.map((e) => ActionModel.fromJson(e))
              .toList() ?? [],
    );
  }
}

class AlertModel {
  final String title;
  final String message;
  final bool isWarning;

  AlertModel({required this.title, required this.message, required this.isWarning});

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isWarning: json['isWarning'] ?? false,
    );
  }
}

class ActionModel {
  final String title;
  final String description;

  ActionModel({required this.title, required this.description});

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
