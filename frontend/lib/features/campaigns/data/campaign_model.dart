class CampaignModel {
  final String? id;
  final String title;
  final String description;
  final int daysTotal;
  final int daysCompleted;
  final bool isActive;
  final String category;

  CampaignModel({
    this.id,
    required this.title,
    required this.description,
    required this.daysTotal,
    required this.daysCompleted,
    required this.isActive,
    required this.category,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      daysTotal: json['daysTotal'] ?? 7,
      daysCompleted: json['daysCompleted'] ?? 0,
      isActive: json['isActive'] ?? false,
      category: json['category'] ?? 'General',
    );
  }
}
