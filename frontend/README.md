# Medbuddy - Health Intelligence App

Medibuddy is a data-driven health platform that uses AI to analyze medical reports, track health trends over time, and provide personalized health challenges (Micro-Campaigns).

## File Structure

The project follows a **Feature-First Architecture** to maintain high modularity and separation of concerns.

```text
lib/
├── core/                       # Core configuration and shared utilities
│   ├── constants/              # Global variables (Scaling, API, App Info)
│   │   └── app_constants.dart
│   ├── network/                # API Client and network configurations
│   ├── theme/                  # Shadcn-inspired medical theme
│   │   └── app_theme.dart
│   └── utils/                  # Reusable services (Storage, File Handling)
│       └── file_storage_service.dart
├── features/                   # Feature-based modules
│   ├── authentication/         # Login & Registration logic
│   ├── campaigns/              # Personalized health challenges
│   ├── home/                   # Dashboard & Health snapshots
│   ├── navigation/             # Main Shell (Bottom Nav + FAB)
│   ├── profile/                # User health context & preferences
│   ├── report_analyzer/        # File upload & AI Insight logic
│   ├── settings/               # App & Account settings
│   ├── splash/                 # Entry animation & Auth routing
│   ├── timeline/               # Metric trend graphing (fl_chart)
├── routes/                     # GoRouter Navigation logic
│   └── app_router.dart
├── shared/                     # Global reusable UI components
│   └── widgets/
│       ├── button.dart         # Shadcn-style buttons
│       ├── input.dart          # Form input fields
│       └── medical_card.dart   # Universal card transformation widget
└── main.dart                   # App entry point
```

# Getting Started

**Prerequisites**

- Flutter SDK (Stable)
- Java 11+ (for Android builds)
- Xcode (for iOS builds)

**Installation**

1. Clone Repo and go into frontend

```bash
git clone https://github.com/sarveshghodke-7/Google_Developer_Solution_Challenge_2k26-EternalX
cd Google_Developer_Solution_Challenge_2k26-EternalX 
cd frontend
```
1. Install dependencies

```bash
flutter pub get 
# if you are using fvm do (fvm flutter pub get)
```
1. Run

```bash
flutter run
```

# The Constants System

We use a centralized constants system located in `lib/core/constants/app_constants.dart`. This ensures that changes to the UI (Padding, Radius) or App Info (Name) are reflected instantly across the entire project.

**Example: How to change the App Name**

To change the branding from "MediCare AI" to something else, locate the `appName` variable in `AppConstants`:

```bash
// lib/core/constants/app_constants.dart

class AppConstants {
  // Change this string to update the name everywhere (Splash, Dashboard, etc.)
  static const String appName = "Your New App Name"; 
  
  static const String appVersion = "1.0.0";
}
```
