import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/toon_parser.dart';
import '../../campaigns/data/campaign_model.dart';
import '../../../shared/widgets/medical_card.dart';
import '../../../core/network/api_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, String>> _trends = [];
  CampaignModel? _activeCampaign;
  bool _isLoadingTrends = true;
  bool _isLoadingCampaign = true;

  @override
  void initState() {
    super.initState();
    _fetchTrends();
    _fetchCampaign();
  }

  Future<void> _fetchCampaign() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final data = await _apiService.fetchCampaigns(userId);
      final campaigns = data.map((json) => CampaignModel.fromJson(json)).toList();
      final active = campaigns.where((c) => c.isActive).toList();
      
      if (mounted) {
        setState(() {
          if (active.isNotEmpty) _activeCampaign = active.first;
          _isLoadingCampaign = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCampaign = false);
    }
  }

  Future<void> _fetchTrends() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final toonString = await _apiService.fetchTrends(userId);
      final parsed = ToonParser.parse(toonString);
      
      if (mounted) {
        setState(() {
          _trends = List<Map<String, String>>.from(parsed['trends'] ?? []);
          _isLoadingTrends = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingTrends = false);
    }
  }

  void _safeNavigate(BuildContext context, String route) {
    Future.microtask(() => context.push(route));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          InkWell(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.surface, 
              child: Icon(Icons.person_outline, size: 20, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: AppConstants.paddingL),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppConstants.paddingXL, 
          right: AppConstants.paddingXL, 
          top: AppConstants.paddingXL, 
          bottom: 30.0, 
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning,\n${user?.displayName ?? 'User'}',
              style: theme.textTheme.headlineMedium?.copyWith(
                height: 1.1, 
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
            
            MedicalCard.primary(
              title: 'Analyze New Report',
              subtitle: 'Upload results for AI insights',
              icon: Icons.add_circle_outline,
              onTap: () => _safeNavigate(context, '/upload'),
            ),
            
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Health Trends', style: theme.textTheme.titleMedium),
                TextButton(
                  onPressed: () => _safeNavigate(context, '/timeline'),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingM),
            
            _isLoadingTrends 
              ? const Center(child: CircularProgressIndicator())
              : _trends.isEmpty
                  ? Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Empty / No data uploaded', style: theme.textTheme.bodyMedium),
                    ))
                  : MedicalCard.trend(
                      title: _trends.first['title'] ?? 'Trend',
                      subtitle: _trends.first['description'] ?? '',
                      icon: _trends.first['status'] == 'positive' ? Icons.trending_up : Icons.trending_down,
                      onTap: () => _safeNavigate(context, '/timeline'),
                  ),
            
            const SizedBox(height: 32),

            Text('Current Challenge', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingM),
            
            _isLoadingCampaign 
              ? const Center(child: CircularProgressIndicator())
              : _activeCampaign == null 
                  ? Center(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('No active challenges. Join one!', style: theme.textTheme.bodyMedium),
                    ))
                  : MedicalCard.progress(
                      title: _activeCampaign!.title,
                      daysLeft: '${_activeCampaign!.daysTotal - _activeCampaign!.daysCompleted} days left',
                      progress: _activeCampaign!.daysTotal > 0 ? _activeCampaign!.daysCompleted / _activeCampaign!.daysTotal : 0,
                      onTap: () => _safeNavigate(context, '/campaigns'),
                  ),
            
            const SizedBox(height: 32),
            
            Text('Quick Access', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppConstants.paddingL),
            
            GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: AppConstants.paddingL,
                mainAxisSpacing: AppConstants.paddingL,
                childAspectRatio: 1.5,
                children: [
                  MedicalCard.quick(
                    title: 'Meds', 
                    icon: Icons.medication_outlined,
                    onTap: () => _safeNavigate(context, '/medications'),
                  ),
                  MedicalCard.quick(
                    title: 'Visits', 
                    icon: Icons.calendar_month_outlined, 
                    onTap: () => _safeNavigate(context, '/visits'),
                  ),
                  MedicalCard.quick(
                    title: 'Support', 
                    icon: Icons.chat_bubble_outline, 
                    onTap: () => _safeNavigate(context, '/support'),
                  ),
                  MedicalCard.quick(
                    title: 'Settings', 
                    icon: Icons.settings_outlined, 
                    onTap: () => _safeNavigate(context, '/settings'),
                  ),
                ],
            ),          
          ],
        ),
      ),
    );
  }
}
