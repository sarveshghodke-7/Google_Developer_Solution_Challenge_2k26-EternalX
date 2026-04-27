import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/button.dart';
import '../data/campaign_model.dart';
import '../../../core/constants/app_constants.dart';

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
        title: const Text('Health Campaigns'), 
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Active Challenges', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppConstants.paddingL),
            
            if (activeCampaigns.isEmpty)
              Text('No active challenges. Pick one below!', style: Theme.of(context).textTheme.bodyMedium)
            else
              ...activeCampaigns.map((c) => _buildActiveCampaignCard(context, c)),
              
            const SizedBox(height: AppConstants.paddingXL),
            
            Text('Recommended For You', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingS),
            Text('Based on your latest lipid panel results.', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppConstants.paddingL),
            
            ...recommendedCampaigns.map((c) => _buildRecommendedCampaignCard(context, c)),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveCampaignCard(BuildContext context, CampaignModel campaign) {
    final double progress = campaign.daysCompleted / campaign.daysTotal;
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingL),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                campaign.title, 
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: AppConstants.tightPadding,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  'Day ${campaign.daysCompleted} of ${campaign.daysTotal}', 
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            campaign.description, 
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: AppConstants.paddingL),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
            color: theme.colorScheme.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(AppConstants.radiusExtraSmall),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCampaignCard(BuildContext context, CampaignModel campaign) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingL),
      padding: AppConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: AppConstants.paddingS),
              Text(
                campaign.title, 
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(campaign.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingL),
          ShadcnButton(
            text: 'Join Challenge',
            isOutlined: true,
            onPressed: () {
              print('Joined ${campaign.title}');
            },
          ),
        ],
      ),
    );
  }
}
