import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/button.dart';
import '../data/campaign_model.dart';

class CampaignsScreen extends StatelessWidget {
  final List<CampaignModel> campaigns;

  const CampaignsScreen({super.key, required this.campaigns});

  @override
  Widget build(BuildContext context) {
    final activeCampaigns = campaigns.where((c) => c.isActive).toList();
    final recommendedCampaigns = campaigns.where((c) => !c.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Health Campaigns', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Active Challenges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (activeCampaigns.isEmpty)
              const Text('No active challenges. Pick one below!', style: TextStyle(color: AppTheme.textMuted))
            else
              ...activeCampaigns.map((c) => _buildActiveCampaignCard(c)),
              
            const SizedBox(height: 40),
            
            const Text('Recommended For You', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Based on your latest lipid panel results.', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
            const SizedBox(height: 16),
            ...recommendedCampaigns.map((c) => _buildRecommendedCampaignCard(c)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCampaignCard(CampaignModel campaign) {
    final double progress = campaign.daysCompleted / campaign.daysTotal;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(campaign.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Day ${campaign.daysCompleted} of ${campaign.daysTotal}', 
                  style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(campaign.description, style: const TextStyle(color: AppTheme.textPrimary, height: 1.4)),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.borderColor,
            color: AppTheme.primaryColor,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCampaignCard(CampaignModel campaign) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(campaign.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(campaign.description, style: const TextStyle(color: AppTheme.textMuted, height: 1.4)),
          const SizedBox(height: 16),
          ShadcnButton(
            text: 'Join Challenge',
            isOutlined: true,
            onPressed: () {
              // Logic to mark as active
              print('Joined ${campaign.title}');
            },
          ),
        ],
      ),
    );
  }
}
