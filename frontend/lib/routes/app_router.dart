import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/splash/presentation/splash_screen.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/report_analyzer/presentation/upload_screen.dart';
import '../features/report_analyzer/presentation/insights_screen.dart';
import '../features/report_analyzer/data/report_insight_model.dart';
import '../features/campaigns/presentation/campaigns_screen.dart';
import '../features/campaigns/data/campaign_model.dart';
import '../features/timeline/presentation/timeline_screen.dart';
import '../features/timeline/data/timeline_model.dart';
import '../features/navigation/presentation/main_wrapper.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../core/services/api_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        GoRoute(
          path: '/upload',
          builder: (BuildContext context, GoRouterState state) {
            return const UploadScreen();
          },
        ),
        GoRoute(
          path: '/insights',
          builder: (BuildContext context, GoRouterState state) {
            // InsightsScreen receives data via GoRouter extra (set by UploadScreen)
            final insightData = state.extra as ReportInsightModel?;

            if (insightData == null) {
              // Fallback: should not happen in normal flow
              return const _InsightsLoadingFallback();
            }

            return InsightsScreen(insightData: insightData);
          },
        ),
        GoRoute(
          path: '/campaigns',
          builder: (BuildContext context, GoRouterState state) {
            return const _CampaignsFetcher();
          },
        ),
        GoRoute(
          path: '/timeline',
          builder: (BuildContext context, GoRouterState state) {
            return const _TimelineFetcher();
          },
        ),
        GoRoute(
          path: '/settings',
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsScreen();
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
      ],
    ),
  ],
);

// ─── Data-Fetching Wrapper Widgets ────────────────────────────────────────────
// These are lightweight wrappers that call the API and pass real data to the
// presentation screens. They live here to keep the screen widgets pure/dumb.

class _CampaignsFetcher extends StatelessWidget {
  const _CampaignsFetcher();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService.instance.getCampaigns(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScaffold(message: 'Loading campaigns…');
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _ErrorScaffold(
            message: snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Could not load campaigns.',
          );
        }

        final rawList =
            (snapshot.data!['campaigns'] as List<dynamic>? ?? []);
        final campaigns =
            rawList.map((e) => CampaignModel.fromJson(e as Map<String, dynamic>)).toList();

        return CampaignsScreen(campaigns: campaigns);
      },
    );
  }
}

class _TimelineFetcher extends StatelessWidget {
  const _TimelineFetcher();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ApiService.instance.getTimeline(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScaffold(message: 'Loading health trends…');
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _ErrorScaffold(
            message: snapshot.error is ApiException
                ? (snapshot.error as ApiException).message
                : 'Could not load timeline.',
          );
        }

        // Empty state: user hasn't uploaded enough reports yet
        if (snapshot.data!.isEmpty) {
          return const _EmptyTimelineScaffold();
        }

        final metricsData = snapshot.data!.map(
          (key, value) => MapEntry(
            key,
            TimelineModel.fromJson(value as Map<String, dynamic>),
          ),
        );

        return TimelineScreen(metricsData: metricsData);
      },
    );
  }
}

// ─── Shared Utility Scaffolds ─────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  final String message;
  const _LoadingScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}

class _ErrorScaffold extends StatelessWidget {
  final String message;
  const _ErrorScaffold({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTimelineScaffold extends StatelessWidget {
  const _EmptyTimelineScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Timeline')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_graph_rounded, size: 64, color: Color(0xFF0F766E)),
              const SizedBox(height: 24),
              const Text(
                'No trends yet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload at least two medical reports to see how your health metrics change over time.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InsightsLoadingFallback extends StatelessWidget {
  const _InsightsLoadingFallback();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined,
                size: 64, color: Color(0xFF0F766E)),
            const SizedBox(height: 16),
            const Text('No report data found.'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.go('/upload'),
              child: const Text('Upload a Report'),
            ),
          ],
        ),
      ),
    );
  }
}
