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
        final dummyApiJson = {
          "reportTitle": "Lipid Panel Blood Test",
          "date": "April 27, 2026",
          "explanation": "Cholesterol is a waxy substance in your blood. While your body needs it to build cells, having too much LDL (bad) cholesterol can cause buildup in your arteries...",
          "alerts": [
            {
              "title": "Attention Needed",
              "message": "Your LDL Cholesterol is elevated at 160 mg/dL.",
              "isWarning": true
            }
          ],
          "actions": [
            {
              "title": "Dietary Changes",
              "description": "Reduce saturated fats and eliminate trans fats."
            },
            {
              "title": "Exercise",
              "description": "Aim for 30 minutes of moderate exercise 5 times a week."
            }
          ]
        };
        final data = ReportInsightModel.fromJson(dummyApiJson);

        return InsightsScreen(insightData: data);
      },
    ),
    GoRoute(
      path: '/campaigns',
      builder: (BuildContext context, GoRouterState state) {
        final List<Map<String, dynamic>> mockApiData = [
          {
            "title": "7-Day No Sugar Challenge",
            "description": "Cut out all processed sugars to help regulate your glucose levels.",
            "daysTotal": 7,
            "daysCompleted": 2,
            "isActive": true,
            "category": "Diet"
          },
          {
            "title": "Daily Step Goal",
            "description": "Walk 8,000 steps a day to improve cardiovascular health and lower LDL.",
            "daysTotal": 30,
            "daysCompleted": 0,
            "isActive": false,
            "category": "Exercise"
          }
        ];

        final campaigns = mockApiData.map((json) => CampaignModel.fromJson(json)).toList();
        return CampaignsScreen(campaigns: campaigns);
      },
    ),
    GoRoute(
        path: '/timeline',
        builder: (BuildContext context, GoRouterState state) {
        final fullApiJson = {
          "LDL Cholesterol": {
            "metricName": "LDL Cholesterol",
            "unit": "mg/dL",
            "dataPoints": [
              {"x": 0, "y": 185, "label": "Jan"},
              {"x": 1, "y": 170, "label": "Feb"},
              {"x": 2, "y": 175, "label": "Mar"},
              {"x": 3, "y": 160, "label": "Apr"}
            ],
            "history": [
              {"date": "April 27, 2026", "title": "Lipid Panel", "changeText": "-15 mg/dL", "isImprovement": true},
              {"date": "March 15, 2026", "title": "Lipid Panel", "changeText": "+5 mg/dL", "isImprovement": false}
            ]
          },
          "Fasting Glucose": {
          "metricName": "Fasting Glucose",
          "unit": "mg/dL",
          "dataPoints": [
            {"x": 0, "y": 95, "label": "Jan"},
            {"x": 1, "y": 98, "label": "Feb"},
            {"x": 2, "y": 110, "label": "Mar"},
            {"x": 3, "y": 105, "label": "Apr"}
          ],
            "history": [
            {"date": "April 10, 2026", "title": "Blood Sugar Test", "changeText": "-5 mg/dL", "isImprovement": true}
            ]
          }
        };
        final Map<String, TimelineModel> metricsData = fullApiJson.map(
            (key, value) => MapEntry(key, TimelineModel.fromJson(value))
            );

        return TimelineScreen(metricsData: metricsData);
      },
    ),
  ],
);
