import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/widgets/button.dart';
import '../../../shared/widgets/input.dart';
import '../data/campaign_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_service.dart';

class CampaignsScreen extends StatefulWidget {
  const CampaignsScreen({super.key});

  @override
  State<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends State<CampaignsScreen> {
  final ApiService _apiService = ApiService();
  List<CampaignModel> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCampaigns();
  }

  Future<void> _fetchCampaigns() async {
    setState(() => _isLoading = true);
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final data = await _apiService.fetchCampaigns(userId);
      if (mounted) {
        setState(() {
          _campaigns = data.map((json) => CampaignModel.fromJson(json)).toList();
          if (_campaigns.isEmpty) {
            _loadDemoCampaigns();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadDemoCampaigns() async {
    final demos = [
      {
        "title": "7-Day No Sugar Challenge",
        "description": "Cut out all processed sugars to help regulate your glucose levels.",
        "daysTotal": 7,
        "daysCompleted": 0,
        "isActive": false,
        "category": "Diet"
      },
      {
        "title": "Daily Step Goal",
        "description": "Walk 8,000 steps a day to improve cardiovascular health.",
        "daysTotal": 30,
        "daysCompleted": 0,
        "isActive": false,
        "category": "Exercise"
      }
    ];
    for (var demo in demos) {
      await _apiService.addCampaign(demo);
    }
    _fetchCampaigns();
  }

  Future<void> _joinCampaign(CampaignModel campaign) async {
    if (campaign.id == null) return;
    try {
      await _apiService.updateCampaign(campaign.id!, {'isActive': true});
      _fetchCampaigns();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Joined ${campaign.title}!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error joining campaign')));
      }
    }
  }

  void _showCreateChallengeSheet() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final daysController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          padding: EdgeInsets.only(
            top: 24, left: 24, right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Custom Challenge', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 24),
              ShadcnInput(hintText: 'Challenge Name', controller: titleController),
              const SizedBox(height: 16),
              ShadcnInput(hintText: 'Description', controller: descController),
              const SizedBox(height: 16),
              ShadcnInput(hintText: 'Total Days', controller: daysController, keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              ShadcnButton(
                text: 'Create Challenge',
                onPressed: () async {
                  if (titleController.text.isEmpty || daysController.text.isEmpty) return;
                  Navigator.pop(context);
                  await _apiService.addCampaign({
                    'title': titleController.text,
                    'description': descController.text,
                    'daysTotal': int.tryParse(daysController.text) ?? 7,
                    'daysCompleted': 0,
                    'isActive': true,
                    'category': 'Custom',
                  });
                  _fetchCampaigns();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCampaigns = _campaigns.where((c) => c.isActive).toList();
    final recommendedCampaigns = _campaigns.where((c) => !c.isActive).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Health Campaigns'), 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateChallengeSheet,
        child: const Icon(Icons.add),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
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
              const SizedBox(height: 60), 
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
              Expanded(
                child: Text(
                  campaign.title, 
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(campaign.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppConstants.paddingL),
          ShadcnButton(
            text: 'Join Challenge',
            isOutlined: true,
            onPressed: () => _joinCampaign(campaign),
          ),
        ],
      ),
    );
  }
}
